# ThinkDirtyAssignment
<p float="left">
  <img src="https://user-images.githubusercontent.com/113945857/192202038-5dbe86d0-1ea9-4530-82db-5243ce32dd5c.jpg" width="400" />
  <img src="https://user-images.githubusercontent.com/113945857/192202058-0058e394-9da5-4674-bb22-93fa18788ea7.jpg" width="400" /> 
</p>

## Build tools & versions used
Xcode 14, iOS15

## Steps to run the app

Install https://github.com/SwiftGen/SwiftGen through Homebrew preferably

## What areas of the app did you focus on?

Simplicity for the junior developers. ViewModel has a factory method to trigger Actions (Inputs) and a local State, that represents one or more View's local States.
AppState is injected for app-wide state which is often useful, but only for the sake of preview in this project. Coordinators play big part in extracting
navigation code from the Views.

## What was the reason for your focus? What problems were you trying to solve?

I aim for the fastest development speed + simplicity/fragmentation of the screens that can be reused throughout the app. With SwiftUI it's easy to create complexity 
whereas it is originally meant for small views.

## How long did you spend on this project?

About 3.5 hours.

## Did you make any trade-offs for this project? What would you have done differently with more time?

Nothing, this structure is perfect, but I think I could've skipped EmptyList view because skeletons are of no use when the request load time is less than 2 seconds.

## What do you think is the weakest part of your project?

You tell me! I could've done more to image caching, but Kindfisher requires custom ImageProcessor to be written if I wanted to implement pre-heating, 
and this would also require limit-offset API.

## Did you copy any code or dependencies? Please make sure to attribute them here!

Stinsen for coordinators, NetworkLogger.swift & Reachability.swift
