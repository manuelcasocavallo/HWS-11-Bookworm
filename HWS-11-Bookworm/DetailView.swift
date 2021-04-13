//
//  DetailView.swift
//  HWS-11-Bookworm
//
//  Created by Manuel Casocavallo on 13/04/21.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let addedDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    let book: Book
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    Text(self.book.genre ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                Text(self.book.title ?? "Unknown Title")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding([.top, .horizontal])
                
                Text(self.book.author ?? "Unknown Author")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Text(self.book.review ?? "No review")
                    
                    .padding()
                
                Text("Added on: \(book.date ?? Date(), formatter: self.addedDateFormatter)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                    .padding()
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert){
            Alert(
                title: Text("Delete Book"),
                message: Text("Are you sure?"),
                primaryButton: .destructive(Text("Delete")){
                    deleteBook()
                },
                secondaryButton: .cancel())
        }
        .navigationBarItems(trailing: Button(action: { showingDeleteAlert = true} ) { Image(systemName: "trash") } )
    }
    
    func deleteBook() {
        moc.delete(book)
        try? moc.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This is a great book, I really enjoyed it."
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
