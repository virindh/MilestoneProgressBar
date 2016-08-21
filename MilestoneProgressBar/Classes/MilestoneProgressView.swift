//
//  MilestoneProgressBar.swift
//
//  Created by Virindh Borra on 8/20/16.
//  Copyright © 2016 Virindh Borra. All rights reserved.
//

import UIKit

public class Milestone {
    
    var progress: Float!
    var image: UIImage!
    var shouldLightUp: Bool!
    var lightUpColor: UIColor?
    
    init(milestoneProgess: Float!, milestoneImage: UIImage!, milestoneShouldLightUp: Bool!, milestoneLightUpColor: UIColor?) {
        progress = milestoneProgess
        image = milestoneImage
        shouldLightUp = milestoneShouldLightUp
        lightUpColor = milestoneLightUpColor
    }
    
    enum MilestoneSize {
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
    
    var milestones: [Milestone]! = []
    var barHeight:CGFloat = 1.0 {
        didSet {
            sizeToFit()
            updateBar()
        }
    }
    
    
    var milestoneSize: Milestone.MilestoneSize = .Medium {
        didSet {
            updateBar()
        }
    }
    var defaultMilestoneLightUpColor: UIColor = UIColor.grayColor()
    
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
                let imageViewSideLength = frame.width/milestoneSize.milestoneSideLengthScaleForSize
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
    func addMilestone(newMilestone: Milestone?) -> Bool {
        if newMilestone != nil {
            milestones.append(newMilestone!)
            milestones.sortInPlace{$0.progress <= $1.progress}
            updateBar()
            return true
        }
        return false
    }
    
    //Returns if adding the milestone was successful
    func addMilestoneWith(progress:Float!, image:UIImage!, shouldLightUp:Bool!, lightUpColor:UIColor?) -> Bool {
        return addMilestone(Milestone(milestoneProgess: progress, milestoneImage: image, milestoneShouldLightUp: shouldLightUp, milestoneLightUpColor:lightUpColor))
    }
    
    //Returns if adding the milestone was successful, assumes lightUpColor is nil
    func addMilestoneWith(progress:Float!, image:UIImage!, shouldLightUp:Bool!) -> Bool {
        return addMilestoneWith(progress, image: image, shouldLightUp: shouldLightUp, lightUpColor: nil)
    }
    
    //Returns if adding the milestone was successful, assumes shouldLightUp is false
    func addMilestoneWith(progress:Float!, image:UIImage!) -> Bool {
        return addMilestoneWith(progress, image: image, shouldLightUp: false)
    }
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        let newSize = CGSizeMake(frame.size.width,barHeight);
        return newSize;
    }
    
    func removeAllMilestones() {
        milestones.removeAll()
        updateBar()
    }
    
    private func updateBar() {
        setProgress(progress, animated: false)
    }
}
