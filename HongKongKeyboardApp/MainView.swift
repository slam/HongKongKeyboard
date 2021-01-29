import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Text("To enable 粵語拼音")
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(.red)
                .padding()
            VStack(alignment: .leading) {
                HStack(spacing: 5) {
                    Text("Open")
                    Button("Settings", action: {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                    })
                }.padding()
                HStack(spacing: 5) {
                    Text("Tap")
                    Text("Keyboards")
                        .fontWeight(.bold)
                }.padding()
                HStack(spacing: 5) {
                    Text("Turn on")
                    Text("粵語拼音")
                        .fontWeight(.bold)
                }.padding()
                HStack(spacing: 5) {
                    Text("Turn on")
                    Text("Allow Full Access")
                        .fontWeight(.bold)
                }.padding()
            }
            Spacer()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
