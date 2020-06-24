//
//  testingView.swift
//  SDDP-iFit-Team3
//
//  Created by 182381J  on 6/24/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SwiftUI

struct testingView: View {
    var body: some View {
   
        
        TabView{
                   
                   Home().tabItem {
                       
                       Image("home").font(.title)
                   }
                   
                   Text("activity").tabItem {
                       
                       Image("activity").font(.title)
                   }
                   
                   Text("search").tabItem {
                       
                       Image("search").font(.title)
                   }
                   
                   Text("person").tabItem {
                       
                       Image("Setting").font(.title)
                   }
               }
        

    }
    
    
}

struct Home : View {
    
    var body : some View{
        
        VStack(alignment: .leading,spacing: 12){
            
            HStack{
                
                Button(action: {
                    
                }) {
                    
                    Image("menu").renderingMode(.original)
                }
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    
                    Image("Profile").renderingMode(.original)
                }
            }
            
            Text("Find More").fontWeight(.heavy).font(.largeTitle).padding(.top,15)
            
            HStack{
                
                Button(action: {
                    
                }) {
                    
                    Text("Experiences").fontWeight(.heavy).foregroundColor(.black)
                }
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    
                    Text("Adventures").foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    
                }) {
                    
                    Text("Activities").foregroundColor(.gray)
                }
            }.padding([.top],30)
            .padding(.bottom, 15)
        
//            MiddleView()
//
//            BottomView().padding(.top, 10)
            
        }.padding()
    }
}

struct testingView_Previews: PreviewProvider {
    static var previews: some View {
        testingView()
    }
}


