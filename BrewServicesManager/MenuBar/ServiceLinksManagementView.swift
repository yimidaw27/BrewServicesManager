//
//  ServiceLinksManagementView.swift
//  BrewServicesManager
//

import SwiftUI

struct ServiceLinksManagementView: View {
    @Environment(ServiceLinksStore.self) private var linksStore

    let serviceName: String
    let suggestedPorts: [ServicePort]
    let onDismiss: () -> Void

    @State private var showingAddLink = false
    @State private var editingLink: ServiceLink?

    var body: some View {
        ZStack {
            // Main list view
            ServiceLinksManagementListView(
                serviceName: serviceName,
                suggestedPorts: suggestedPorts,
                onDismiss: onDismiss,
                showingAddLink: $showingAddLink,
                editingLink: $editingLink
            )
                .opacity(showingAddLink || editingLink != nil ? 0 : 1)

            // Add link form overlay
            if showingAddLink {
                AddServiceLinkView(
                    serviceName: serviceName,
                    onSave: { url, label in
                        linksStore.addLink(ServiceLink(url: url, label: label), to: serviceName)
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showingAddLink = false
                        }
                    },
                    onCancel: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            showingAddLink = false
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }

            // Edit link form overlay
            if let link = editingLink {
                EditServiceLinkView(
                    link: link,
                    onSave: { url, label in
                        linksStore.updateLink(link.id, in: serviceName, url: url, label: label)
                        withAnimation(.easeInOut(duration: 0.2)) {
                            editingLink = nil
                        }
                    },
                    onCancel: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            editingLink = nil
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
    }
}
