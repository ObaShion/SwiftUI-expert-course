//
//  ZukanModel.swift
//  Ip-Zukan
//
//  Created by 大場史温 on 2025/06/28.
//

import Foundation

struct ZukanModel {
    var id = UUID()
    var name: String
    var detail: String
    var lat: Double
    var lon: Double
}


class DemoData {
    let data: [ZukanModel] = [
        ZukanModel(name: "ニホンザル", detail: "日本の固有種で、本州・四国・九州に生息する唯一のサル。温泉に入ることで知られています。", lat: 35.6762, lon: 139.6503),
        ZukanModel(name: "タヌキ", detail: "日本の民話や伝説に多く登場する動物。夜行性で、都市部でも見かけることがあります。", lat: 34.6851, lon: 135.8048),
        ZukanModel(name: "キツネ", detail: "日本の神話や伝説に重要な役割を果たす動物。稲荷神社の神使としても知られています。", lat: 36.2048, lon: 138.2529),
        ZukanModel(name: "イノシシ", detail: "日本全国に分布する野生の豚。農作物を荒らす害獣としても知られています。", lat: 33.5902, lon: 130.4017),
        ZukanModel(name: "シカ", detail: "奈良公園で有名なニホンジカ。日本全国の森林に生息しています。", lat: 34.6851, lon: 135.8048),
        ZukanModel(name: "クマ", detail: "ヒグマとツキノワグマが生息。北海道のヒグマは特に大型で有名です。", lat: 43.0644, lon: 141.3468),
        ZukanModel(name: "カモシカ", detail: "日本の固有種で、国の特別天然記念物。山岳地帯に生息する美しい動物です。", lat: 36.2048, lon: 138.2529),
        ZukanModel(name: "ヤマネ", detail: "日本の固有種で、世界最小級のげっ歯類。冬眠する習性があります。", lat: 35.6762, lon: 139.6503),
        ZukanModel(name: "ムササビ", detail: "夜行性の滑空動物。木から木へ滑空して移動する姿が特徴的です。", lat: 34.6851, lon: 135.8048),
        ZukanModel(name: "アライグマ", detail: "外来種として日本に定着。手先が器用で、都市部でも見かけることがあります。", lat: 36.2048, lon: 138.2529),
        ZukanModel(name: "ハクビシン", detail: "東南アジア原産の外来種。果実を好み、農作物に被害を与えることもあります。", lat: 35.6762, lon: 139.6503),
        ZukanModel(name: "ニホンリス", detail: "日本の森林に生息する小型のリス。木の実を貯蔵する習性があります。", lat: 34.6851, lon: 135.8048),
        ZukanModel(name: "ウサギ", detail: "ニホンノウサギは日本の固有種。野山や草原に生息しています。", lat: 36.2048, lon: 138.2529),
        ZukanModel(name: "モグラ", detail: "地中に生息する小型哺乳類。土を掘って生活するため、畑の土壌改良に役立ちます。", lat: 35.6762, lon: 139.6503),
        ZukanModel(name: "コウモリ", detail: "夜行性の哺乳類。日本には約30種が生息し、害虫を食べる益獣です。", lat: 34.6851, lon: 135.8048)
    ]
    // ダミーデータ by chatGPT
}
