//
//  IACollectionAlignedLayout.swift
//  SegurosMtyiOS
//
//  Created by Ritesh-Gupta & Juan Eduardo Pacheco Osornio on 21/12/17.
//  Copyright © 2017 IA Interactive. All rights reserved.
//  Based on Ritesh' TagCellLayout work.
//

import UIKit

// MARK: - Delegate Declaration for Layout
protocol IACollectionAlignedLayoutDelegate: NSObjectProtocol {
    func alignedItemWidth(layout: IACollectionAlignedLayout, atIndex index: Int) -> CGFloat
    func alignedItemFixedHeight(layout: IACollectionAlignedLayout) -> CGFloat
}

// MARK: - Alignment Type Enum
enum ItemAlignmentType: Int {
    case Left
    case Center
    case Right

    var distributionFactor: CGFloat {
        var factor: CGFloat
        switch self {
            case .Center: factor = 2
            default: factor = 1
        }
        return factor
    }
}

// MARK: - Layout Class Declaration
class IACollectionAlignedLayout: UICollectionViewLayout {

    // MARK: - Properties
    struct AlignedCellLayoutInfo {
        var layoutAttribute: UICollectionViewLayoutAttributes
        var whitespace: CGFloat

        init(layoutAttribute: UICollectionViewLayoutAttributes) {
            self.layoutAttribute = layoutAttribute
            self.whitespace = 0
        }
    }

    var layoutInfoList = [AlignedCellLayoutInfo]()
    var itemAlignmentType = ItemAlignmentType.Center
    var numberOfItemsInCurrentRow = 0
    var currentItemIndex: Int = 0
    var lineNumber = 1
    weak var delegate: IACollectionAlignedLayoutDelegate?

    var currentItemLayoutInfo: AlignedCellLayoutInfo? {
        let index = max(0, currentItemIndex - 1)
        if layoutInfoList.count > index {
            return layoutInfoList[index]
        } else {
            return nil
        }
    }

    var currentItemPosition: CGPoint {
        guard let info = currentItemLayoutInfo?.layoutAttribute else { return .zero }
        var position = info.frame.origin
        position.x += info.bounds.width
        return position
    }

    var itemsCount: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }

    var collectionViewWidth: CGFloat {
        return collectionView?.frame.size.width ?? 0
    }

    var isLastRow: Bool {
        return currentItemIndex == (itemsCount - 1)
    }

    // MARK: - Init
    init(alignmentType: ItemAlignmentType = .Center, delegate: IACollectionAlignedLayoutDelegate) {
        super.init()
        self.delegate = delegate
        self.itemAlignmentType = alignmentType
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - Overriden Methods
    override func prepare() {

        // Reset Layout State
        layoutInfoList = [AlignedCellLayoutInfo]()
        numberOfItemsInCurrentRow = 0
        lineNumber = 1

        // Setup Layout
        if let delegate = delegate, collectionView != nil {
            basicLayoutSetup(delegate: delegate)
            handleItemAlignment()
        } else {
            debugPrint("No se pudo configurar el layout de Especialidades")
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return layoutInfoList.count > indexPath.row ? layoutInfoList[indexPath.row].layoutAttribute : nil
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if layoutInfoList.count > 0 {
            return layoutInfoList
                .map { $0.layoutAttribute }
                .filter { rect.intersects($0.frame) }
        } else {
            return nil
        }
    }

    override var collectionViewContentSize: CGSize {
        if let lineHeight = delegate?.alignedItemFixedHeight(layout: self), let width = collectionView?.frame.size.width {
            let height = lineHeight * CGFloat(lineNumber)
            return CGSize(width: width, height: height)
        } else {
            return .zero
        }
    }

    class func textWidth(text: String, font: UIFont) -> CGFloat {
        let padding: CGFloat = 4.0
        let label = UILabel()
        label.text = text
        label.font = font
        label.sizeToFit()
        return label.frame.width + padding
    }

    // MARK: - Private Methods *****************************************************************************

    private func basicLayoutSetup(delegate: IACollectionAlignedLayoutDelegate) {
        for itemIndex in 0 ..< itemsCount {
            currentItemIndex = itemIndex
            createLayoutAttributes()
            configureWhitespace()
            configurePositionForNextItem()
            handleWhitespaceForLastRow()
        }
    }

    private func handleItemAlignment() {
        if let collectionView = collectionView, itemAlignmentType != .Left {
            let itemsCount = collectionView.numberOfItems(inSection: 0)
            for itemIndex in 0 ..< itemsCount {
                var itemFrame = layoutInfoList[itemIndex].layoutAttribute.frame
                let whitespace = layoutInfoList[itemIndex].whitespace
                itemFrame.origin.x += whitespace
                let tagAttribute = layoutAttribute(itemIndex: itemIndex, itemFrame: itemFrame)
                layoutInfoList[itemIndex].layoutAttribute = tagAttribute
            }
        }
    }

    private func createLayoutAttributes() {
        if let delegate = delegate {
            let itemHeight = delegate.alignedItemFixedHeight(layout: self)
            let itemWidth = delegate.alignedItemWidth(layout: self, atIndex: currentItemIndex)
            let itemSize = CGSize(width: itemWidth, height: itemHeight)

            let layoutInfo = itemCellLayoutInfo(itemIndex: currentItemIndex, itemSize: itemSize)
            layoutInfoList.append(layoutInfo)
        }
    }

    private func itemCellLayoutInfo(itemIndex: Int, itemSize: CGSize) -> AlignedCellLayoutInfo {
        var itemFrame = CGRect(origin: currentItemPosition, size: itemSize)

        // Move down item if goes out of screen
        if currentItemPosition.x + itemSize.width > collectionViewWidth {
            itemFrame.origin.x = 0
            itemFrame.origin.y += itemSize.height
        }

        let attribute = layoutAttribute(itemIndex: itemIndex, itemFrame: itemFrame)
        let info = AlignedCellLayoutInfo(layoutAttribute: attribute)
        return info
    }

    private func layoutAttribute(itemIndex: Int, itemFrame: CGRect) -> UICollectionViewLayoutAttributes {
        let indexPath = IndexPath(item: itemIndex, section: 0)
        let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        layoutAttribute.frame = itemFrame
        return layoutAttribute
    }

    private func configureWhitespace() {
        let layoutInfo = layoutInfoList[currentItemIndex].layoutAttribute
        let tagWidth = layoutInfo.frame.size.width
        if currentItemPosition.x + tagWidth > collectionViewWidth {
            lineNumber += 1
            applyWhitespace(startingIndex: currentItemIndex - 1)
        }
    }

    private func configurePositionForNextItem() {
        let layoutInfo = layoutInfoList[currentItemIndex].layoutAttribute
        let moveItem = currentItemPosition.x + layoutInfo.frame.size.width > collectionViewWidth
        numberOfItemsInCurrentRow = moveItem ? 1 : numberOfItemsInCurrentRow + 1
    }

    private func handleWhitespaceForLastRow() {
        if isLastRow { applyWhitespace(startingIndex: itemsCount - 1) }
    }

    private func applyWhitespace(startingIndex: Int) {
        let lastIndex = startingIndex - numberOfItemsInCurrentRow
        let whitespace = calculateWhiteSpace(itemIndex: startingIndex)
        for itemIndex in lastIndex + 1 ..< startingIndex + 1 {
            insertWhiteSpace(itemIndex: itemIndex, whiteSpace: whitespace)
        }
    }

    private func calculateWhiteSpace(itemIndex: Int) -> CGFloat {
        let itemFrame = itemIndex > -1 ? layoutInfoList[itemIndex].layoutAttribute.frame : .zero
        let whiteSpace = collectionViewWidth - (itemFrame.origin.x + itemFrame.size.width)
        return whiteSpace
    }

    private func insertWhiteSpace(itemIndex: Int, whiteSpace: CGFloat) {
        var info = layoutInfoList[itemIndex]
        let factor = itemAlignmentType.distributionFactor
        info.whitespace = whiteSpace / factor
        layoutInfoList[itemIndex] = info
    }
}

// MARK: - Extensions
extension Float {
    func cgValue() -> CGFloat {
        return CGFloat(self)
    }
}
