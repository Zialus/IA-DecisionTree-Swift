import Foundation

class KMeans<Label: Hashable> {
    let numCenters: Int
    var labels: [Label]
    var centroids = [Vector]()

    init(labels: [Label]) {
        assert(labels.count > 1, "Exception: KMeans with less than 2 centers.")
        self.labels = labels
        self.numCenters = labels.count
    }

    private func indexOfNearestCenter(x: Vector, centers: [Vector]) -> Int {
        var nearestDist = Double.infinity
        var minIndex = 0

        for (idx, center) in centers.enumerate() {
            let dist = x.distanceTo(center)
            if dist < nearestDist {
                minIndex = idx
                nearestDist = dist
            }
        }
        return minIndex
    }

    func trainCenters(points: [Vector], convergeDistance: Double) {
        let zeroVector = Vector([Double](count: points[0].length, repeatedValue: 0))

        // Randomly take k objects from the input data to make the initial centroids.
        var centers = reservoirSample(points, k: numCenters)

        var centerMoveDist = 0.0
        repeat {
            // This array keeps track of which data points belong to which centroids.
            var classification: [[Vector]] = .init(count: numCenters, repeatedValue: [])

            // For each data point, find the centroid that it is closest to.
            for p in points {
                let classIndex = indexOfNearestCenter(p, centers: centers)
                classification[classIndex].append(p)
            }

            // Take the average of all the data points that belong to each centroid.
            // This moves the centroid to a new position.
            let newCenters = classification.map { assignedPoints in
                assignedPoints.reduce(zeroVector, combine: +) / Double(assignedPoints.count)
            }

            // Find out how far each centroid moved since the last iteration. If it's
            // only a small distance, then we're done.
            centerMoveDist = 0.0
            for idx in 0..<numCenters {
                centerMoveDist += centers[idx].distanceTo(newCenters[idx])
            }

            centers = newCenters
        } while centerMoveDist > convergeDistance

        centroids = centers
    }

    func fit(point: Vector) -> Label {
        assert(!centroids.isEmpty, "Exception: KMeans tried to fit on a non trained model.")

        let centroidIndex = indexOfNearestCenter(point, centers: centroids)
        return labels[centroidIndex]
    }

    func fit(points: [Vector]) -> [Label] {
        assert(!centroids.isEmpty, "Exception: KMeans tried to fit on a non trained model.")

        return points.map(fit)
    }
}

// Pick k random elements from samples
func reservoirSample<T>(samples: [T], k: Int) -> [T] {
    var result = [T]()
    
    // Fill the result array with first k elements
    for i in 0..<k {
        result.append(samples[i])
    }
    
    // Randomly replace elements from remaining pool
    for i in k..<samples.count {
        let j = Int(random() % (i + 2))
//        let j = Int(arc4random_uniform(UInt32(i + 1)))
        if j < k {
            result[j] = samples[i]
        }
    }
    return result
}
