import ProximityReader
import UIKit

class ProximityReaderPlugin : ProximityReaderPlatformApi {
    func isAccountLinked(token: String, completion: @escaping (Result<Bool, any Error>) -> Void) {
        handleResult(completion) {
            guard #available(iOS 16.4, *) else {
                throw createUnsupportedOperatingSystem("16.4");
            }

            let paymentToken = PaymentCardReader.Token(rawValue: token)
            let reader = PaymentCardReader()
            return try await reader.isAccountLinked(using: paymentToken)
        }
    }

    func linkAccount(token: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        handleResult(completion) {
            guard #available(iOS 15.4, *) else {
                throw createUnsupportedOperatingSystem("15.4");
            }

            let readerToken = PaymentCardReader.Token(rawValue: token)
            let reader = PaymentCardReader()
            try await reader.linkAccount(using: readerToken)
        }
    }

    func presentHowToTap(completion: @escaping (Result<Void, any Error>) -> Void) {
        handleResult(completion) {
            try await self._presentHowToTap()
        }
    }

    @MainActor
    private func _presentHowToTap() async throws {
        guard #available(iOS 18.0, *) else {
            throw createUnsupportedOperatingSystem("18.0");
        }

        guard let viewController = _topViewController() else {
            throw createPigeonError(".state_error", "No visible UIViewController to present from");
        }

        let discovery = ProximityReaderDiscovery()
        let content = try await discovery.content(for: .payment(.howToTap))
        try await discovery.presentContent(content, from: viewController)
    }

    @MainActor
    private func _topViewController() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let windows = scenes.filter { $0.activationState == .foregroundActive }.flatMap { $0.windows }
            + scenes.flatMap { $0.windows }
        let window = windows.first { $0.isKeyWindow } ?? windows.first { !$0.isHidden }

        var top = window?.rootViewController
        while let presented = top?.presentedViewController, !presented.isBeingDismissed {
            top = presented
        }
        return top
    }
}
