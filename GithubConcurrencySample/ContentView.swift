//
//  ContentView.swift
//  GithubConcurrencySample
//
//  Created by Yusuke Hasegawa on 2021/09/16.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ViewModel = .init()
    
    var body: some View {

        VStack {
            
            TextField.init("search respository", text: $viewModel.query)
                .padding(4)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Divider()
            
            Group {
                

                
                if !viewModel.hasError {
                    
                    VStack {
                        if viewModel.loading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .frame(width: 50, height: 50)
                                .scaleEffect(2.0)
                        }
                        
                        //show list
                        List {
                            ForEach.init(viewModel.items) { item in
                                RepositoryRow(item: item)
                            }
                        }.frame(maxHeight: .infinity)
                        
                    }                    
                    
                } else {
                    //show error
                    
                    VStack {
                        Image(systemName: "xmark.octagon.fill")
                            .font(.system(size: 80))
                        Text("Error").font(.title)
                        Text(self.viewModel.errorMessage).font(.body)
                    }
                    .padding()
                    .foregroundColor(.gray)
                    
                }
            }.frame(maxHeight: .infinity)
            
        }
        

    }
}

extension SearchRepositoryItem: Identifiable { }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

