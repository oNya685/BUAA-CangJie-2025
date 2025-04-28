package ProducerConsumerSyncDemo

import std.sync.MultiConditionMonitor
import std.sync.ConditionID
import std.sync.sleep
import std.collection.LinkedList
import std.collection.ArrayList
import std.random.Random
import std.time.Duration

let QUEUE_CAPACITY = 5
let PRODUCERS_COUNT = 1
let CONSUMERS_COUNT = 1
let NUMBERS_TO_PRODUCE = 20

class SharedQueue {
    let queue = LinkedList<UInt8>()
    let lock = MultiConditionMonitor()
    let notEmpty: ConditionID
    let notFull: ConditionID
    var end: Bool

    init() {
        lock.lock()
        notEmpty = lock.newCondition()
        notFull = lock.newCondition()
        end = false
        lock.unlock()
    }

    func push(value: UInt8) {
        lock.lock()
        while (queue.size == QUEUE_CAPACITY) {
            lock.wait(notFull)
        }
        queue.append(value)
        println("生产者放入：${value}")
        // println(queue)
        lock.notify(notEmpty)
        lock.unlock()
    }

    func pop(): UInt8 {
        lock.lock()
        while (queue.isEmpty() && !end) {
            lock.wait(notEmpty)
        }
        if (queue.isEmpty() && end) {
            lock.unlock()
            return 0
        }
        let value = queue.popFirst().getOrThrow()
        println("消费者取出：${value}")
        // println(queue)
        lock.notify(notFull)
        lock.unlock()
        return value
    }

    func setEnd() {
        lock.lock()
        end = true
        lock.notifyAll(notEmpty)
        lock.unlock()
    }
}

let QUEUE = SharedQueue()

func produce(): Int64 {
    for (count in 0 .. NUMBERS_TO_PRODUCE) {
        let number = 1 + Random().nextUInt8(10)
        QUEUE.push(number)
        if (count != NUMBERS_TO_PRODUCE - 1) {
            let duration = Duration.second * (1.0 + 2.0 * Random().nextFloat64())
            sleep(duration)
        }
    }
    return 0
}

func consume(): Int64 {
    while (true) {
        if (QUEUE.pop() == 0) { break }
        sleep(Duration.second * 2)
    }
    return 0
}

main(): Int64 {

    let producers = ArrayList<Future<Int64>>()
    let consumers = ArrayList<Future<Int64>>()

    for (i in 0..PRODUCERS_COUNT) {
        producers.append(spawn{=> produce()})
    }
    for (i in 0..CONSUMERS_COUNT) {
        consumers.append(spawn{=> consume()})
    }

    for (i in 0..PRODUCERS_COUNT) {
        producers[i].get()
    }
    QUEUE.setEnd()
    for (i in 0..CONSUMERS_COUNT) {
        consumers[i].get()
    }

    return 0
}
