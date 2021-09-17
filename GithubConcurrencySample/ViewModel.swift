//
//  ViewModel.swift
//  GithubConcurrencySample
//
//  Created by Yusuke Hasegawa on 2021/09/17.
//

import Foundation
import Combine

@MainActor
class ViewModel: ObservableObject {
    
    @Published var query: String = ""
    @Published var items: [SearchRepositoryItem] = []
    @Published var loading: Bool = false
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
    
    private var cancellations = Set<AnyCancellable>()
    private let apiClient = ApiClient()
    
    init() {
        
        debugPrint("*** init")
        
        $query
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.doSearch(text: $0) })
            .store(in: &cancellations)
        
    }
    
}

private extension ViewModel {
    
    func doSearch(text: String) {
        
        if text.isEmpty {
            return
        }
        
        debugPrint("doSearch: \(text)")
        
        Task {
            self.loading = true
            do {
                let response =  try await apiClient.searchRepositories(query: text)
                self.items = response.items
                self.hasError = false
            } catch let error {
                debugPrint(error)
                self.hasError = true
                self.errorMessage = error.localizedDescription
            }
            self.loading = false
        }
        
    }
    
}
