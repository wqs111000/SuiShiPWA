import Cocoa
import WebKit

final class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    private var statusItem: NSStatusItem!
    private let popover = NSPopover()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusItem = NSStatusBar.system.statusItem(withLength: 28)
        statusItem.button?.font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        statusItem.button?.alignment = .center
        statusItem.button?.wantsLayer = true
        statusItem.button?.layer?.borderWidth = 1
        statusItem.button?.layer?.borderColor = NSColor.labelColor.withAlphaComponent(0.85).cgColor
        statusItem.button?.layer?.cornerRadius = 4
        statusItem.button?.target = self
        statusItem.button?.action = #selector(togglePopover)
        updateTitle()
        popover.behavior = .transient
        popover.delegate = self
        popover.contentSize = NSSize(width: 420, height: 620)
        let web = WKWebView(frame: .zero)
        web.setValue(false, forKey: "drawsBackground")
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = web
        if let root = Bundle.main.resourceURL {
            web.loadFileURL(root.appendingPathComponent("index.html"), allowingReadAccessTo: root)
        }
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in self?.updateTitle() }
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }
        if popover.isShown { popover.performClose(nil) }
        else { popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY); popover.contentViewController?.view.window?.makeKey() }
    }

    private func updateTitle() {
        let f = DateFormatter(); f.locale = Locale(identifier: "zh_CN"); f.dateFormat = "d"
        statusItem?.button?.title = f.string(from: Date())
        statusItem?.button?.toolTip = "岁时 · 点击打开日历"
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
