//
//  EditProjectView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 28/04/22.
//

import SwiftUI

struct EditProjectView: View {
    let project: Project

    @EnvironmentObject var dataController: DataController

    @State private var title: String
    @State private var detail: String
    @State private var color: String

    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]

    init(project: Project) {
        self.project = project

        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var previews: some View {
        EditProjectView(project: Project.example)
    }
}
