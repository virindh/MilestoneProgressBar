//
//  MilestoneProgressBar.swift
//
//  Created by Virindh Borra on 8/20/16.
//  Copyright © 2016 Virindh Borra. All rights reserved.
//

import UIKit

public class Milestone {
    
    public var progress: Float!
    public var image: UIImage!
    public var shouldLightUp: Bool!
    public var lightUpColor: UIColor?
    
    public init(milestoneProgess: Float!, milestoneImage: UIImage!, milestoneShouldLightUp: Bool!, milestoneLightUpColor: UIColor?) {
        progress = milestoneProgess
        image = milestoneImage
        shouldLightUp = milestoneShouldLightUp
        lightUpColor = milestoneLightUpColor
    }
    
    public enum MilestoneSize {
        case Small
        case Medium
        case Large
        var milestoneSideLengthScaleForSize: CGFloat {
            switch self {
            case .Small:
                return 20.0
            case .Medium:
                return 10.0
            case .Large:
                return 5.0
            }
        }
    }
}

public class MilestoneProgressBar: UIProgressView {
    
    public var milestones: [Milestone]! = []
    public var barHeight:CGFloat = 1.0 {
        didSet {
            sizeToFit()
            updateBar()
        }
    }
    public var barWidth:CGFloat = 1.0 {
        didSet {
            sizeToFit()
            updateBar()
        }
    }
    
    public var barSize:CGSize! {
        didSet {
            barHeight = barSize.height
            barWidth = barSize.width
        }
    }
    
    public var milestoneSize: Milestone.MilestoneSize = .Medium {
        didSet {
            updateBar()
        }
    }
    public var defaultMilestoneLightUpColor: UIColor = UIColor.grayColor()
    
    override public func setProgress(progress: Float, animated: Bool) {
        //Remove all milestones(milestones may have changed)
        superview?.subviews.forEach {
            if ($0 is UIImageView && $0.restorationIdentifier == "Milestone Image") {
                $0.removeFromSuperview()
            }
        }
        //Draw Milestones
        if milestones != nil {
            for milestone in milestones {
                var milestoneImage = milestone.image
                if milestoneImage == nil {
                    milestoneImage = UIImage()
                }
                let imageViewSideLength = barWidth/milestoneSize.milestoneSideLengthScaleForSize
                let imageViewX = (frame.width) * CGFloat(milestone.progress) + frame.origin.x - imageViewSideLength/2
                let imageViewY = frame.origin.y + barHeight/2 - imageViewSideLength/2
                let imageView = UIImageView(frame: CGRect(x: imageViewX, y: imageViewY, width: imageViewSideLength, height: imageViewSideLength))
                imageView.image = milestoneImage
                imageView.contentMode = .ScaleAspectFit
                imageView.restorationIdentifier = "Milestone Image" //Needed: a better way to identify idividual imageviews that were added by MilestoneProgressBar
                if milestone.progress <= progress && milestone.shouldLightUp {
                    //This milestone should be lit up(tinted)
                    imageView.image = imageView.image?.imageWithRenderingMode(.AlwaysTemplate)
                    imageView.tintColor = milestone.lightUpColor ?? defaultMilestoneLightUpColor
                }
                superview?.insertSubview(imageView, aboveSubview: self)
            }
        }
        super.setProgress(progress, animated: true)
    }
    
    //Returns if adding the milestone was successful
    public func addMilestone(newMilestone: Milestone?) -> Bool {
        if newMilestone != nil {
            milestones.append(newMilestone!)
            milestones.sortInPlace{$0.progress <= $1.progress}
            updateBar()
            return true
        }
        return false
    }
    
    //Returns if adding the milestone was successful
    public func addMilestoneWith(progress:Float!, image:UIImage!, shouldLightUp:Bool!, lightUpColor:UIColor?) -> Bool {
        return addMilestone(Milestone(milestoneProgess: progress, milestoneImage: image, milestoneShouldLightUp: shouldLightUp, milestoneLightUpColor:lightUpColor))
    }
    
    //Returns if adding the milestone was successful, assumes lightUpColor is nil
    public func addMilestoneWith(progress:Float!, image:UIImage!, shouldLightUp:Bool!) -> Bool {
        return addMilestoneWith(progress, image: image, shouldLightUp: shouldLightUp, lightUpColor: nil)
    }
    
    //Returns if adding the milestone was successful, assumes shouldLightUp is false
    public func addMilestoneWith(progress:Float!, image:UIImage!) -> Bool {
        return addMilestoneWith(progress, image: image, shouldLightUp: false)
    }
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        let newSize = CGSizeMake(barWidth,barHeight);
        return newSize;
    }
    
    public func removeAllMilestones() {
        milestones.removeAll()
        updateBar()
    }
    
    private func updateBar() {
        setProgress(progress, animated: false)
        layer.cornerRadius = barHeight * (3/6)
        layer.masksToBounds = true
        clipsToBounds = true
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        updateBar()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateBar()
    }
    
    public override func didMoveToSuperview() {
        sizeToFit()
        updateBar()
    }
}
