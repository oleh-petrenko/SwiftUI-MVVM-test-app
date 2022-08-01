//
//  UserRow.swift
//  RaiffeisenTest
//
//  Created by Oleh Petrenko on 01.08.2022.
//

import SwiftUI

struct UserRow: View {
    
    let user: User
    
    var body: some View {
        HStack {
            AsyncImage(url: user.avatarUrl) {
                Text("...")
            } image: { Image(uiImage: $0).resizable() }.frame(width: 32.0, height: 32.0)
            Text(user.login)
        }
    }
    
}

struct UserRow_Previews: PreviewProvider {
    static var previews: some View {
        UserRow(user: User.testUser)
    }
}
