//
//  Wrapper.swift
//  BusVal
//
//  Created by Pablo on 29/02/2021.
//

import Alamofire
import Foundation
import SwiftSoup
import SwiftUI
import SWXMLHash

// swiftlint:disable type_body_length file_length
struct Wrapper {
    // MARK: ENDPOINTS

    enum Endpoint {
        case stops, stop, stopTime, lines, line, schedule, news, newImage, card

        // MARK: Internal

        func getPath(id: String? = nil) -> String {
            switch self {
            case .stops:
                return "http://auvasa.es/dataapp/Paradas.xml"
            case .stop:
                return "http://auvasa.es/rssparada.asp?codigo=\(id!)"
            case .stopTime:
                return "http://www.auvasa.es/parada.asp?codigo=\(id!)"
            case .lines:
                return "http://auvasa.es/dataapp/Lineas.xml"
            case .line:
                return "http://auvasa.es/rsstrayectos.asp?codigo=\(id!)"
            case .schedule:
                return "http://auvasa.es/dataapp/Horarios.xml"
            case .news:
                return "http://auvasa.es/rss.asp"
            case .newImage:
                return "http://www.auvasa.es/images/news/\(id!).jpg"
            case .card:
                return "http://2.139.171.116:3506/rsstarjeta.asp?codigo=\(id!)"
            }
        }
    }

    // MARK: RESPONSES

    enum CardDetailsReponse {
        case success(CardBalance, [CardMovement])
        case failure(APIError)
    }

    enum StopTimeResponse {
        case success([[String]])
        case failure(APIError)
    }

    enum LineSchedulesResponse {
        case success(LineSchedule)
        case failure(APIError)
    }

    enum StopDetailsResponse {
        case success(StopDetails)
        case failure(APIError)
    }

    enum StopsResponse {
        case success([Stop])
        case failure(APIError)
    }

    enum LineDetailsResponse {
        case success([LineDetails])
        case failure(APIError)
    }

    enum LinesResponse {
        case success([Line])
        case failure(APIError)
    }

    enum NewsResponse {
        case success([New])
        case failure(APIError)
    }

    enum APIError: Error {
        case noResponse
        case invalidParam(error: Error)
        case xmlDecodingError(error: Error)
        case networkError(error: Error)
    }

    static let shared = Wrapper()

    // MARK: NEWS METHODS

    static func getNews(_ completion: @escaping (NewsResponse) -> Void) {
        var news = [New]()
        AF.request(Endpoint.news.getPath())
            .validate(statusCode: 200 ..< 300)
            .response { response in
                switch response.result {
                case .success:
                    let xml = XMLHash.parse(response.data!)
                    for element in xml["rss"]["channel"]["item"].all {
                        news.append(
                            New(
                                title: element["title"].element!.text.components(
                                    separatedBy: "("
                                )[0].components(separatedBy: ")")[0],
                                date: element["title"].element!.text.components(
                                    separatedBy: "("
                                )[1].components(separatedBy: ")")[0],
                                description: element["description"].element!.text,
                                link: element["link"].element!.text,
                                image: element["imag"].element!.text
                            )
                        )
                    }
                    completion(NewsResponse.success(news))
                case let .failure(error):
                    completion(NewsResponse.failure(APIError.networkError(error: error)))
                }
            }
    }

    // MARK: LINES METHODS

    static func getLines(_ completion: @escaping (LinesResponse) -> Void) {
        var data = [Line]()
        AF.request(Endpoint.lines.getPath())
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/xml"])
            .response { response in
                switch response.result {
                case .success:
                    let xml = XMLHash.parse(response.data!)
                    for element in xml["dataroot"]["AppLineas"].all {
                        var type: String
                        if element["Lin"].element!.text.contains("B") {
                            type = "B"
                        } else if element["Lin"].element!.text.contains("F") {
                            type = "F"
                        } else if element["Lin"].element!.text.contains("P") {
                            type = "P"
                        } else if element["Lin"].element!.text.contains("M") {
                            type = "M"
                        } else if element["Lin"].element!.text.contains("C") {
                            type = "C"
                        } else if element["Lin"].element!.text.contains("H") {
                            type = "H"
                        } else if element["Lin"].element!.text.contains("U") {
                            type = "U"
                        } else {
                            type = "#"
                        }
                        data.append(
                            Line(
                                line: element["Lin"].element!.text,
                                name: element["Nombre"].element!.text,
                                friendlyName: """
                                    Línea \(element["Lin"].element!.text): \(element["Nombre"].element!.text)
                                """,
                                startJourney: element["Trayecto1"].element?.text,
                                returnJourney: element["Trayecto2"].element?.text,
                                type: type
                            )
                        )
                    }
                    completion(LinesResponse.success(data))
                case let .failure(error):
                    completion(LinesResponse.failure(APIError.networkError(error: error)))
                }
            }
    }

    static func getLineDetails(_ line: String?, completion: @escaping (LineDetailsResponse) -> Void) {
        var data = [LineDetails]()
        AF.request(Endpoint.line.getPath(id: line))
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/xml"])
            .response { response in
                switch response.result {
                case .success:
                    let xml = XMLHash.parse(response.data!)
                    let journeys = xml["dataroot"]["Trayectos"].all
                    for element in journeys where element["OrdenTrayecto"].element?.text == "1" {
                        data.append(
                            LineDetails(
                                order: element["Orden"].element!.text,
                                line: element["Línea"].element!.text,
                                orderJourney: element["OrdenTrayecto"].element!.text,
                                orderStop: element["OrdenParada"].element!.text,
                                stop: element["Parada"].element!.text,
                                corr: element["Correspondencias"].element!.text,
                                ext: element["Extensión"].element!.text,
                                code: element["Codigo"].element!.text,
                                coordinateX: Double(element["cX"].element!.text)!,
                                coordinateY: Double(element["cY"].element!.text)!,
                                pos: element["Pos"].element!.text
                            )
                        )
                    }
                    completion(LineDetailsResponse.success(data))
                case let .failure(error):
                    completion(LineDetailsResponse.failure(APIError.networkError(error: error)))
                }
            }
    }

    static func getLineReturnDetails(_ line: String?, completion: @escaping (LineDetailsResponse) -> Void) {
        var data = [LineDetails]()
        AF.request(Endpoint.line.getPath(id: line))
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/xml"])
            .response { response in
                switch response.result {
                case .success:
                    let xml = XMLHash.parse(response.data!)
                    let journeys = xml["dataroot"]["Trayectos"].all
                    for element in journeys where element["OrdenTrayecto"].element?.text == "2" {
                        data.append(LineDetails(
                            order: element["Orden"].element!.text,
                            line: element["Línea"].element!.text,
                            orderJourney: element["OrdenTrayecto"].element!.text,
                            orderStop: element["OrdenParada"].element!.text,
                            stop: element["Parada"].element!.text,
                            corr: element["Correspondencias"].element!.text,
                            ext: element["Extensión"].element!.text,
                            code: element["Codigo"].element!.text,
                            coordinateX: Double(element["cX"].element!.text)!,
                            coordinateY: Double(element["cY"].element!.text)!,
                            pos: element["Pos"].element!.text
                        )
                        )
                    }
                    completion(LineDetailsResponse.success(data))
                case let .failure(error):
                    completion(LineDetailsResponse.failure(APIError.networkError(error: error)))
                }
            }
    }

    // MARK: STOPS METHODS

    static func getStops(_ completion: @escaping (StopsResponse) -> Void) {
        var data = [Stop]()
        AF.request(Endpoint.stops.getPath())
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/xml"])
            .response { response in
                switch response.result {
                case .success:
                    let xml = XMLHash.parse(response.data!)
                    for element in xml["dataroot"]["AppParadas"].all {
                        let stop = Stop(
                            code: element["Codigo"].element!.text,
                            name: element["Parada"].element!.text,
                            friendlyName: """
                                Parada \(element["Codigo"].element!.text): \(element["Parada"].element!.text)
                            """,
                            coordinateX: Double(element["cX"].element!.text)!,
                            coordinateY: Double(element["cY"].element!.text)!,
                            corr: element["Corr"].element?.text
                        )
                        data.append(stop)
                    }
                    completion(StopsResponse.success(data))
                case let .failure(error):
                    completion(StopsResponse.failure(APIError.networkError(error: error)))
                }
            }
    }

    static func getStopDetails(_ id: String?, completion: @escaping (StopDetailsResponse) -> Void) {
        AF.request(Endpoint.stop.getPath(id: id))
            .validate(statusCode: 200 ..< 300)
            .response { response in
                switch response.result {
                case .success:
                    let xml = XMLHash.parse(response.data!)
                    let element = xml["rss"]["channel"].children
                    if element[1].element?.text != "NODATAPAR" {
                        let data = StopDetails(
                            title: element[0].element!.text,
                            name: element[1].element!.text,
                            code: element[2].element!.text,
                            coordinateX: Double(element[3].element!.text)!,
                            coordinateY: Double(element[4].element!.text)!,
                            corr: element[5].element?.text,
                            desc: element[6].element!.text,
                            lang: element[7].element!.text
                        )
                        completion(StopDetailsResponse.success(data))
                    } else {
                        completion(StopDetailsResponse.failure(APIError.noResponse))
                    }
                case let .failure(error):
                    completion(StopDetailsResponse.failure(APIError.networkError(error: error)))
                }
            }
    }

    static func getStopTime(_ id: String?, completion: @escaping (StopTimeResponse) -> Void) {
        var data: [[String]] = []
        AF.request(Endpoint.stopTime.getPath(id: id))
            .validate(statusCode: 200 ..< 300)
            .response { response in
                switch response.result {
                case .success:
                    do {
                        let html = String(decoding: response.data!, as: UTF8.self)
                        let doc: Document = try SwiftSoup.parse(html)
                        for row in try doc.select("table tbody") {
                            var temp: [String] = []
                            for element in try row.select("tr td") {
                                if let text = try? element.text() {
                                    if !text.isEmpty {
                                        temp.append(
                                            text.utf8EncodedString()
                                                .replacingOccurrences(of: "ufffd", with: "ñ")
                                                .replacingOccurrences(of: "\\", with: "")
                                        )
                                    }
                                }
                            }
                            data.append(temp)
                        }
                    } catch {
                        data = [[]]
                    }
                    completion(StopTimeResponse.success(data))
                case let .failure(error):
                    completion(StopTimeResponse.failure(APIError.networkError(error: error)))
                }
            }
    }

    // MARK: SCHEDULES METHODS

    static func getLineSchedule(_ line: String?, completion: @escaping (LineSchedulesResponse) -> Void) {
        AF.request(Endpoint.schedule.getPath())
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["text/xml"])
            .response { response in
                switch response.result {
                case .success:
                    let xml = XMLHash.parse(response.data!)
                    for element in xml["dataroot"]["AppHorarios"].all where element["Lin"].element?.text == line {
                        let data = LineSchedule(
                            line: element["Lin"].element!.text,
                            weekdays: element["Laborables"].element!.text,
                            saturdays: element["Sábados"].element!.text,
                            festive: element["Festivos"].element!.text,
                            note: element["Nota"].element?.text
                        )
                        completion(LineSchedulesResponse.success(data))
                    }
                case let .failure(error):
                    completion(LineSchedulesResponse.failure(APIError.networkError(error: error)))
                }
            }
    }

    // MARK: CARD METHODS

    static func getCardDetails(_ card: String?, completion: @escaping (CardDetailsReponse) -> Void) {
        var movements = [CardMovement]()
        AF.request(Endpoint.card.getPath(id: card))
            .validate(statusCode: 200 ..< 300)
            .validate(contentType: ["application/rss+xml"])
            .response { response in
                switch response.result {
                case .success:
                    let xml = XMLHash.parse(response.data!)
                    let description = xml["rss"]["channel"]["description"].element!.text
                    if description == "NODATA" {
                        completion(CardDetailsReponse.failure(APIError.noResponse))
                    } else {
                        let balance = CardBalance(balance: xml["rss"]["channel"]["saldomonedero"].element!.text)
                        for element in xml["rss"]["channel"]["item"].all {
                            movements.append(
                                CardMovement(
                                    date: element["fecha"].element!.text,
                                    type: element["tipoop"].element!.text,
                                    ammount: element["importe"].element!.text,
                                    balance: element["saldo"].element!.text
                                )
                            )
                        }
                        completion(CardDetailsReponse.success(balance, movements))
                    }
                case let .failure(error):
                    completion(CardDetailsReponse.failure(APIError.networkError(error: error)))
                }
            }
    }
}
