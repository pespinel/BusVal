//
//  UIKitTabView.swift
//  BusVal
//
//  Created by Pablo on 28/12/21.
//

import SwiftUI

// MARK: - UIKitTabView

struct UIKitTabView: View {
    // MARK: Lifecycle

    init(selection: Binding<Int>, @TabBuilder _ content: () -> [TabBarItem]) {
        _selectedIndex = selection

        (viewControllers, tabBarItems) = content().reduce(into: ([], [])) { result, next in
            let tabController = UIHostingController(rootView: next.view)
            tabController.tabBarItem = next.barItem
            result.0.append(tabController)
            result.1.append(next)
        }
    }

    // MARK: Internal

    var body: some View {
        TabBarController(
            controllers: viewControllers,
            tabBarItems: tabBarItems,
            selectedIndex: $selectedIndex
        ).ignoresSafeArea()
    }

    // MARK: Private

    private let viewControllers: [UIHostingController<AnyView>]
    private let tabBarItems: [TabBarItem]

    @Binding private var selectedIndex: Int
}

extension UIKitTabView {
    struct TabBarItem {
        // MARK: Lifecycle

        init<T>(
            title: String,
            image: UIImage?,
            selectedImage: UIImage? = nil,
            badgeValue: String? = nil,
            content: T
        ) where T: View {
            view = AnyView(content)
            barItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
            self.badgeValue = badgeValue
        }

        // MARK: Internal

        let view: AnyView
        let barItem: UITabBarItem
        let badgeValue: String?
    }

    struct TabBarController: UIViewControllerRepresentable {
        let controllers: [UIViewController]
        let tabBarItems: [TabBarItem]

        @Binding var selectedIndex: Int

        func makeUIViewController(context: Context) -> UITabBarController {
            let tabBarController = UITabBarController()
            tabBarController.viewControllers = controllers
            tabBarController.delegate = context.coordinator
            tabBarController.selectedIndex = selectedIndex
            tabBarController.hidesBottomBarWhenPushed = true
            return tabBarController
        }

        func updateUIViewController(_ tabBarController: UITabBarController, context _: Context) {
            tabBarController.selectedIndex = selectedIndex

            tabBarItems.forEach { tab in
                guard let index = tabBarItems.firstIndex(where: { $0.barItem == tab.barItem }),
                      let controllers = tabBarController.viewControllers
                else {
                    return
                }

                guard controllers.indices.contains(index) else {
                    return
                }
                controllers[index].tabBarItem.badgeValue = tab.badgeValue
            }
        }

        func makeCoordinator() -> TabBarCoordinator {
            TabBarCoordinator(self)
        }
    }

    class TabBarCoordinator: NSObject, UITabBarControllerDelegate {
        // MARK: Lifecycle

        init(_ tabBarController: TabBarController) {
            parent = tabBarController
        }

        // MARK: Internal

        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            guard parent.selectedIndex == tabBarController.selectedIndex else {
                parent.selectedIndex = tabBarController.selectedIndex
                return
            }

            guard let navigationController = navigationController(in: viewController) else {
                scrollToTop(in: viewController)
                return
            }

            guard navigationController.visibleViewController == navigationController.viewControllers.first else {
                navigationController.popToRootViewController(animated: true)
                return
            }

            scrollToTop(in: navigationController, selectedIndex: tabBarController.selectedIndex)
        }

        func scrollToTop(in navigationController: UINavigationController, selectedIndex _: Int) {
            let views = navigationController.viewControllers // swiftlint:disable:this flatmap_over_map_reduce
                .map(\.view.subviews)
                .reduce([], +) // swiftlint:disable:this reduce_into

            guard let scrollView = scrollView(in: views) else {
                return
            }
            scrollView.scrollRectToVisible(Self.inlineTitleRect, animated: true)
        }

        func scrollToTop(in viewController: UIViewController) {
            let views = viewController.view.subviews

            guard let scrollView = scrollView(in: views) else {
                return
            }
            scrollView.scrollRectToVisible(Self.inlineTitleRect, animated: true)
        }

        func scrollView(in views: [UIView]) -> UIScrollView? {
            var view: UIScrollView?

            views.forEach {
                guard let scrollView = $0 as? UIScrollView else {
                    view = scrollView(in: $0.subviews)
                    return
                }

                view = scrollView
            }

            return view
        }

        func navigationController(in viewController: UIViewController) -> UINavigationController? {
            var controller: UINavigationController?

            if let navigationController = viewController as? UINavigationController {
                return navigationController
            }

            viewController.children.forEach {
                guard let navigationController = $0 as? UINavigationController else {
                    controller = navigationController(in: $0)
                    return
                }

                controller = navigationController
            }

            return controller
        }

        // MARK: Private

        private static let inlineTitleRect = CGRect(x: 0, y: 0, width: 1, height: 1)

        private var parent: TabBarController
    }
}

// MARK: - TabBuilder

@resultBuilder
enum TabBuilder {
    static func buildBlock(_ elements: UIKitTabView.TabBarItem...) -> [UIKitTabView.TabBarItem] {
        elements
    }
}
