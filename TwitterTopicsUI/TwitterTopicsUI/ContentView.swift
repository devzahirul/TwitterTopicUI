//
//  ContentView.swift
//  TwitterTopicsUI
//
//  Created by Islam Md. Zahirul on 15/9/21.
//

import SwiftUI


enum AppColors: String {
    case black
    case blue
    case extralightgray
    case extraextralightgray
    case lightinggray
    case darkGray
}

extension Color {
    init(_ appColor: AppColors) {
        self.init(appColor.rawValue)
    }
}

struct VerticalLineView: View {
    var color: Color = Color(AppColors.lightinggray)
    var lineHeight: CGFloat = 0.5
    
    var body: some View {
        Rectangle()
            .frame(height: lineHeight)
            .foregroundColor(color)
    }
}


struct TopicView: View {
    
    let topicName: String
    @State var isSelected = false
    
    var body: some View {
        HStack {
        Text(topicName)
            .font(.system(size: 14.0, weight: .regular, design: .default))
            .padding(.horizontal)
            .foregroundColor(isSelected ? Color.white : Color(AppColors.black))
            
            .onTapGesture {
                isSelected.toggle()
            }
            
            Image(systemName: isSelected ? "checkmark" : "plus")
                .font(.system(size: 15.0, weight: .regular, design: .default))
                .padding(.trailing)
                .foregroundColor(isSelected ? .white : Color(AppColors.blue))
        }
            .padding(.vertical, 12.0)
        .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .fill(isSelected ? Color(AppColors.blue) : .white)
        )
            .overlay(
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .strokeBorder()
                .foregroundColor(isSelected ? .clear : Color(AppColors.lightinggray))
            )
        
       
    }
}




struct TopicsSectionView: View {
    let sectionTitle: String
    let topics: [[String]]
    
    //MARK: - UI
    var body: some View {
        VStack {
            VerticalLineView()
            VStack {
                    HStack {
                    Text(sectionTitle)
                        .font(.system(size: 20.0, weight: .bold, design: .default))
                        .foregroundColor(Color(AppColors.black))
                        Spacer()
                    }//:HStack
                    .padding(.horizontal)
                   VerticalLineView()
                }//:VStack
            ScrollView(.horizontal) {
                VStack(alignment: .leading) {
                    ForEach(topics, id: \.self) { columnTopics in
                        HStack {
                            ForEach(columnTopics, id: \.self ) { topic in
                            TopicView(topicName: topic)
                            }
                        }//:HStack
                    }//:ForEach
                }//: VStack
                .padding()
            
            }//: ScrollView
            
           VerticalLineView()
        }
    }
}


struct TopicsHeaderView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.backward")
                Spacer()
                Text("Topics")
                    .font(.system(size: 20.0, weight: .bold, design: .default))
                    .foregroundColor(Color(AppColors.black))
                Spacer()
            }
        }.padding(.horizontal)
    }
}


struct CustomSegmentView: View {
    
    @Binding var selectedIndex: Int
    var segmentNames: [String] = ["Suggested", "Following", "Not Interested"]
    
    func animateIndex(_ current: Int) {
        withAnimation {
            if current < selectedIndex {
                while selectedIndex != current {
                    selectedIndex = selectedIndex - 1
                }
                return
            }
            if current > selectedIndex {
                while selectedIndex != current {
                    selectedIndex = selectedIndex + 1
                }
            }
        }
    }
    
    //MARK: - UI
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ForEach(segmentNames, id: \.self) { segmentName in
                    VStack(spacing: 10.0) {
                        HStack {
                            Spacer()
                        Text(segmentName)
                            .font(.system(size: 16.0, weight: .regular, design: .default))
                            .foregroundColor(Color(AppColors.darkGray))
                            Spacer()
                        }
                    }.onTapGesture {
                        animateIndex(segmentNames.firstIndex(of: segmentName) ?? 0)
                    }
                }//End ForEach
               
                Spacer()
            }
            
            HStack {
            GeometryReader { g in
                VerticalLineView(color: Color(AppColors.blue), lineHeight: 2.0)
                .frame(width: g.size.width/3, height: 1.0)
                .offset(x: (g.size.width/3) * CGFloat(selectedIndex), y: 0.0)
                    .offset(x: 0.0, y: -2.0)
            }.frame(height: 1.0)
            }//: HStack
            
            VerticalLineView()
                .offset(x: 0.0, y: -10.0)
                
        }.padding(.vertical)
    }
}
//V-Blanace 50mili kore din e 2 bar
//Amino vet plus 50mil din e 2 bar
//Calblex 25mili din e 2 bar


struct TopicsSegmentView: View {
    let selectedSegment: Int
    var sectionNames: [String] {
        return [
            "For you",
            "Technology",
            "Science",
            "Only on Twitter",
            "Careers"
        ]
    }
    
    var topics: [[String]] {
        [
            ["Technology", "Litecoin cryptocurrency", "Geography", "Genealogy", "Graduate school", "NEO cryptocurrency"],
            ["Small business", "Adobe", "Vegre cryptocurrency"],
            ["Nonprofits", "Microcontrollers","Tether cryptocurrency"]
        ]
    }
    //MARK: - UI
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                VStack {
            if selectedSegment == 0 {
                suggestedSegmentView
            } else if selectedSegment == 1 {
                followingsSegmentView
            } else {
                notInterestedSegmentView
            }
                }
            }
        }
    }//:body
    
    //Suggested
    var suggestedSegmentView: some View {
        ForEach(sectionNames, id: \.self) {sectionName in
            TopicsSectionView(sectionTitle: sectionName, topics: topics)
        }
    }
    
    //Following
    var followingsSegmentView: some View {
        ForEach(0..<5) {i in
            TopicsSectionView(sectionTitle: "For you", topics: [
            ["Litcoin cryptocurrency", "Technology", ],
                ["Litcoin cryptocurrency", "Technology", ]
            ])
        }
    }
    
    //Not Interested
    var notInterestedSegmentView: some View {
        ForEach(0..<5) {i in
            TopicsSectionView(sectionTitle: "For you", topics: [
            ["Litcoin cryptocurrency", "Technology", ],
                ["Litcoin cryptocurrency", "Technology", ],
                ["Litcoin cryptocurrency", "Technology", ]
            ])
        }
    }
}


struct ContentView: View {
    
    @State var segmentIndex = 0
    
    var body: some View {
        VStack {
           
            TopicsHeaderView()
            CustomSegmentView(selectedIndex: $segmentIndex)
            TopicsSegmentView(selectedSegment: segmentIndex)
            Spacer()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
