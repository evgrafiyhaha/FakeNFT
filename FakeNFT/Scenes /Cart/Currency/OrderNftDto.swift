struct OrderNftDto: Dto {
    let nfts: String

    func asDictionary() -> [String: String] {
        ["nfts": nfts]
    }
}
