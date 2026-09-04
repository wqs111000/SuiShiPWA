import Cocoa
import WebKit

final class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    private var statusItem: NSStatusItem!
    private let popover = NSPopover()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusItem = NSStatusBar.system.statusItem(withLength: 30)
        statusItem.button?.font = NSFont.monospacedDigitSystemFont(ofSize: 12, weight: .semibold)
        statusItem.button?.alignment = .center
        statusItem.button?.wantsLayer = true
        statusItem.button?.layer?.backgroundColor = NSColor.clear.cgColor
        statusItem.button?.layer?.borderWidth = 0.8
        statusItem.button?.layer?.borderColor = NSColor.separatorColor.withAlphaComponent(0.9).cgColor
        statusItem.button?.layer?.cornerRadius = 6
        statusItem.button?.layer?.masksToBounds = true
        statusItem.button?.target = self
        statusItem.button?.action = #selector(togglePopover)
        statusItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
        updateTitle()
        popover.behavior = .transient
        popover.delegate = self
        popover.contentSize = NSSize(width: 420, height: 620)
        let container = NSView()
        container.wantsLayer = true
        container.layer?.backgroundColor = NSColor.clear.cgColor
        let web = WKWebView(frame: .zero)
        web.setValue(false, forKey: "drawsBackground")
        web.translatesAutoresizingMaskIntoConstraints = false
        let quit = NSButton(title: "退出岁时", target: self, action: #selector(quitApp))
        quit.bezelStyle = .recessed
        quit.controlSize = .small
        quit.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(web)
        container.addSubview(quit)
        NSLayoutConstraint.activate([
            web.topAnchor.constraint(equalTo: container.topAnchor),
            web.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            web.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            web.bottomAnchor.constraint(equalTo: quit.topAnchor, constant: -8),
            quit.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            quit.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            quit.heightAnchor.constraint(equalToConstant: 24)
        ])
        popover.contentViewController = NSViewController()
        popover.contentViewController?.view = container
        if let root = Bundle.main.resourceURL {
            web.loadFileURL(root.appendingPathComponent("index.html"), allowingReadAccessTo: root)
        }
        Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in self?.updateTitle() }
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }
        if NSApp.currentEvent?.type == .rightMouseUp {
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "打开岁时日历", action: #selector(openCalendar), keyEquivalent: "o"))
            menu.addItem(.separator())
            menu.addItem(NSMenuItem(title: "退出岁时", action: #selector(quitApp), keyEquivalent: "q"))
            menu.items.forEach { $0.target = self }
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: button.bounds.maxY + 4), in: button)
            return
        }
        if popover.isShown { popover.performClose(nil) }
        else { popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY); popover.contentViewController?.view.window?.makeKey() }
    }

    @objc private func openCalendar() {
        guard let button = statusItem.button else { return }
        if !popover.isShown { popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY) }
    }

    @objc private func quitApp() { NSApp.terminate(nil) }

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
