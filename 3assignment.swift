
    // =============================================================
    //  Station ALMA-7: Rescue Protocol
    //  iOS Mobile Development · Module 3 · Lab Assignment
    //
    //  How to use:
    //   • Xcode: File → New → Playground → Blank, replace everything
    //     with this file's contents.
    //   • Terminal: swift ALMA7_Starter.swift
    //
    //  Rules:
    //   • Do NOT modify the STARTER CODE section.
    //   • `!` (force unwrap) is forbidden: −0.5 points each.
    //   • No map / filter / reduce / compactMap.
    //   • Use the exact function names from the assignment PDF.
    // =============================================================


    // MARK: - =================== STARTER CODE ===================
    // MARK: - Do not modify anything in this section

    typealias Reading = (sensor: String, value: Int)

    /// Splits a string at the first occurrence of the separator.
    /// splitOnce("O2:87", by: ":") -> ("O2", "87")
    /// splitOnce("hello", by: ":") -> nil
    func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
        guard let index = line.firstIndex(of: separator) else { return nil }
        let left = String(line[..<index])
        let right = String(line[line.index(after: index)...])
        return (left, right)
    }

    let rawLog = [
        "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
        "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
        "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
    ]

    class Tank {
        var level: Int
        init(level: Int) { self.level = level }
    }

    class Module {
        let name: String
        var oxygenTank: Tank?
        init(name: String, oxygenTank: Tank?) {
            self.name = name
            self.oxygenTank = oxygenTank
        }
    }

    class CrewMember {
        let name: String
        let role: String
        let priority: Int      // 1 = evacuated first
        var module: Module?    // nil = in open space
        init(name: String, role: String, priority: Int, module: Module?) {
            self.name = name
            self.role = role
            self.priority = priority
            self.module = module
        }
    }

    let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
    let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
    let dock = Module(name: "Dock", oxygenTank: nil)

    let crew = [
        CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
        CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
        CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
        CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
    ]

    var roster: [String: CrewMember] = [:]
    for member in crew { roster[member.name] = member }

    print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

    // MARK: - ================= END OF STARTER CODE =================


    // MARK: - =================== YOUR SOLUTION ===================
    // Uncomment each signature when you start working on it.


    // MARK: Level 1 · Decoding Telemetry

    // 1.1
    func parseReading(_ raw: String) -> Reading? {
        guard let parts = splitOnce(raw, by: ":"),
              parts.0.isEmpty == false,
              let value = Int(parts.1),
              value >= 0 || parts.0 == "TEMP"
        else { return nil }
        return (sensor: parts.0, value: value)
    }

    print(parseReading("O2:87") as Any)
    print(parseReading("TEMP:-12") as Any)
    print(parseReading("RAD:-1") as Any)
    print(parseReading(":55") as Any)

    // 1.2
    func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
        var valid: [Reading] = []
        var invalidCount = 0
        for line in lines {
            if let reading = parseReading(line) {
                valid.append(reading)
            } else {
                invalidCount += 1
            }
        }
        return (valid: valid, invalidCount: invalidCount)
    }

    let parsed = parseLog(rawLog)
    print("Valid:", parsed.valid.count)
    print("Invalid:", parsed.invalidCount)
    print("Test invalid:", parseLog(["O2:50", "bad", "TEMP:-5"]).invalidCount)

    let A = parsed.invalidCount
    print("A =", A)


    // MARK: Level 2 · Analysis

    // 2.1
    func select(_ readings: [Reading], where isIncluded: (Reading) -> Bool) -> [Reading] {
        var result: [Reading] = []
        for reading in readings {
            if isIncluded(reading) {
                result.append(reading)
            }
        }
        return result
    }

    func values(of readings: [Reading]) -> [Int] {
        var result: [Int] = []
        for reading in readings {
            result.append(reading.value)
        }
        return result
    }

    let o2 = select(parsed.valid) { $0.sensor == "O2" }
    print("O2:", values(of: o2))
    let press = select(parsed.valid) { $0.sensor == "PRESS" }
    print("PRESS:", values(of: press))

    // 2.2
    func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
        guard let first = values.first else {
            return nil
        }
        var minValue = first
        var maxValue = first
        var sum = 0
        for v in values {
            if v < minValue { minValue = v }
            if v > maxValue { maxValue = v }
            sum += v
        }
        let average = Double(sum) / Double(values.count)
        return (min: minValue, max: maxValue, average: average)
    }

    func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
        stats(of: values)
    }

    print(stats(3, 8, 1) as Any)
    print(stats() as Any)
    print(stats(of: [10, 20]) as Any)

    let B = Int(stats(of: values(of: o2))?.average ?? 0)
    print("B =", B)

    // 2.3 · The Closure Ladder (5 sorts, then compare results in code)
    let r = parsed.valid

    let s1 = r.sorted(by: { (a: Reading, b: Reading) -> Bool in
        return a.value > b.value
    })
    let s2 = r.sorted(by: { a, b in return a.value > b.value })
    let s3 = r.sorted(by: { a, b in a.value > b.value })
    let s4 = r.sorted(by: { $0.value > $1.value })
    let s5 = r.sorted { $0.value > $1.value }

    let v1 = values(of: s1)
    let allSame = v1 == values(of: s2)
               && v1 == values(of: s3)
               && v1 == values(of: s4)
               && v1 == values(of: s5)
    print("Sorted:", v1)
    print("All equal:", allSame)


    // MARK: Level 3 · Temperature Stabilization

    // 3.1
    func heatUp(_ t: Int) -> Int {
        t + 5
    }

    func coolDown(_ t: Int) -> Int {
        t - 3
    }

    func hold(_ t: Int) -> Int {
        t
    }

    func chooseProtocol(for temp: Int) -> (Int) -> Int {
        if temp < 18 {
            return heatUp
        }
        if temp > 24 {
            return coolDown
        }
        return hold
    }

    print(heatUp(0), coolDown(0), hold(0))
    print(chooseProtocol(for: 10)(10))
    print(chooseProtocol(for: 30)(30))
    print(chooseProtocol(for: 20)(20))

    // 3.2
    func runUntilStable(from start: Int, maxSteps: Int = 10) -> (finalTemp: Int, steps: Int, isStable: Bool) {
        var temp = start
        var steps = 0
        while (temp < 18 || temp > 24) && steps < maxSteps {
            let action = chooseProtocol(for: temp)
            temp = action(temp)
            steps += 1
        }
        let isStable = temp >= 18 && temp <= 24
        return (finalTemp: temp, steps: steps, isStable: isStable)
    }

    print(runUntilStable(from: 31))
    print(runUntilStable(from: -100, maxSteps: 5))
    print(runUntilStable(from: 20))

    let temps = select(parsed.valid) { $0.sensor == "TEMP" }
    let lowestTemp = stats(of: values(of: temps))?.min ?? 0
    print("Lowest TEMP:", lowestTemp)

    let C = runUntilStable(from: lowestTemp).steps
    print("C =", C)


    // MARK: Level 4 · The Crew

    // 4.1
    func oxygenLevel(of member: CrewMember) -> Int? {
        member.module?.oxygenTank?.level
    }

    print(oxygenLevel(of: crew[0]) as Any)
    print(oxygenLevel(of: crew[1]) as Any)
    print(oxygenLevel(of: crew[3]) as Any)

    // 4.2
    func status(of member: CrewMember) -> String {
        guard let level = oxygenLevel(of: member) else {
            let place = member.module?.name ?? "open space"
            return "\(member.name): no data (\(place))"
        }
        if level < 20 {
            return "\(member.name): \(level)% CRITICAL"
        }
        return "\(member.name): \(level)% OK"
    }

    for member in crew {
        print(status(of: member))
    }

    // 4.3
    @discardableResult
    func transferOxygen(from source: inout Int, to target: inout Int, amount: Int) -> Int {
        guard amount > 0 else {
            return 0
        }
        let freeSpace = 100 - target
        let actual = max(0, min(amount, source, freeSpace))
        source -= actual
        target += actual
        return actual
    }

    var tankA = 10
    var tankB = 95
    print(transferOxygen(from: &tankA, to: &tankB, amount: 20), tankA, tankB)
    print(transferOxygen(from: &tankA, to: &tankB, amount: -3), tankA, tankB)
    var tankC = 3
    var tankD = 0
    print(transferOxygen(from: &tankC, to: &tankD, amount: 50), tankC, tankD)

    if let labTank = lab.oxygenTank, let habTank = hab.oxygenTank {
        let moved = transferOxygen(from: &labTank.level, to: &habTank.level, amount: 30)
        print("Transferred:", moved)
    }

    let D = hab.oxygenTank?.level ?? -1
    print("D =", D)

    // 4.4
    func evacuationOrder(_ names: String..., roster: [String: CrewMember]) -> [String] {
        var found: [CrewMember] = []
        for name in names {
            guard let member = roster[name] else {
                print("Unknown crew member: \(name)")
                continue
            }
            found.append(member)
        }
        let sortedMembers = found.sorted { $0.priority < $1.priority }
        var result: [String] = []
        for member in sortedMembers {
            result.append(member.name)
        }
        return result
    }

    print(evacuationOrder("Dana", "Ghost", "Aigerim", "Timur", roster: roster))
    print(evacuationOrder("Nurlan", "Timur", roster: roster))


    // MARK: Level 5 · The Saboteur's Logbook
    // The saboteur's code is below, commented out (it needs your
    // oxygenLevel(of:) to compile). Comment on every problem, then
    // write fixed versions and a test that proves the logic bug is gone.

    /*
    func reportOxygen(for member: CrewMember) -> String {
        let tank = member.module!.oxygenTank!
        // PROBLEM 1: member.module! — Nurlan has module == nil (open space).
        //            Force unwrapping nil crashes the program.
        // PROBLEM 2: .oxygenTank! — Dana is in Dock, which has oxygenTank == nil.
        //            Force unwrapping nil crashes the program.
        return "\(member.name): \(tank.level)%"
    }

    func firstCritical(in crew: [CrewMember]) -> String {
        var result: String?
        for member in crew {
            if oxygenLevel(of: member)! < 20 {
                // PROBLEM 3: oxygenLevel returns nil for Dana and Nurlan.
                //            With the starter crew it crashes on the 2nd element (Dana).
                result = member.name
                // PROBLEM 4 (logic bug, not a !): the loop never stops and keeps
                //            overwriting result, so it returns the LAST critical member,
                //            not the FIRST. Invisible with starter data because only
                //            one member (Aigerim) is critical.
            }
        }
        return result!
        // PROBLEM 5: if nobody is critical (or the array is empty), result == nil
        //            and force unwrapping it crashes the program.
    }
    */

    func reportOxygen(for member: CrewMember) -> String {
        guard let level = oxygenLevel(of: member) else {
            return "\(member.name): no data"
        }
        return "\(member.name): \(level)%"
    }

    func firstCritical(in crew: [CrewMember]) -> String? {
        for member in crew {
            if let level = oxygenLevel(of: member), level < 20 {
                return member.name
            }
        }
        return nil
    }

    for member in crew {
        print(reportOxygen(for: member))
    }

    let testModule1 = Module(name: "Test1", oxygenTank: Tank(level: 5))
    let testModule2 = Module(name: "Test2", oxygenTank: Tank(level: 10))
    let testCrew = [
        CrewMember(name: "First",  role: "Test", priority: 1, module: testModule1),
        CrewMember(name: "NoData", role: "Test", priority: 2, module: nil),
        CrewMember(name: "Second", role: "Test", priority: 3, module: testModule2)
    ]

    let critical = firstCritical(in: testCrew)
    print("First critical:", critical ?? "none")
    print("Logic bug fixed:", critical == "First")
    print("Empty crew -> nil:", firstCritical(in: []) == nil)
    print("Station crew:", firstCritical(in: crew) ?? "none")


    // MARK: Finale · Launch Code

    let launchCode = "\(A)-\(B)-\(C)-\(D)"
    print("LAUNCH CODE: \(launchCode)")


    // MARK: Bonus

    func makeAlarm(threshold: Int) -> (Int) -> Bool {
        var count = 0
        return { level in
            if level < threshold {
                count += 1
                print("Alarm #\(count)")
                return true
            }
            return false
        }
    }

    let alarm = makeAlarm(threshold: 20)
    print(alarm(12))
    print(alarm(40))
    print(alarm(5))

    let alarm2 = makeAlarm(threshold: 50)
    print(alarm2(30))


    // MARK: - ================= DEFENSE QUESTIONS =================
    /*
     1. guard let vs if let beyond syntax:
        A variable unwrapped with guard let stays available after the guard,
        until the end of the function. With if let it only exists inside the
        braces. The else branch of guard must exit the scope (return/continue),
        and the compiler checks this.
        if let gets noticeably worse with several checks — the code turns
        into a "pyramid" and the main logic moves far to the right:
            if let a = Int(x) {
                if let b = Int(y) {
                    if let c = Int(z) { print(a + b + c) }
                }
            }
        With guard, bad cases are filtered out first and the main code stays flat:
            guard let a = Int(x), let b = Int(y), let c = Int(z) else { return }
            print(a + b + c)

     2. Why can't you pass [Int] to stats(_ values: Int...)?
        Int... describes how the function is called: separate values
        separated by commas, stats(1, 2, 3). Turning them into [Int] happens
        only inside the function. The parameter expects individual Ints,
        not an array, and Swift can't "spread" an array into an argument list.
        That's why there is a separate stats(of: [Int]).

     3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?
        Swift forbids two simultaneous inout accesses to the same variable
        (law of exclusivity). Otherwise source and target would be the same
        memory: source -= 5 and target += 5 would cancel out, but the function
        would still report "transferred 5". The result would depend on the
        order of operations and be unpredictable.

     4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?
        oxygenLevel returns Int?, so the default value on the right side of ??
        must be an Int. "no data" is a String. An expression can't be an Int
        in one case and a String in another.

     5. Full type of chooseProtocol and how to read it:
        (Int) -> (Int) -> Int
        Arrows group from the right: (Int) -> ((Int) -> Int).
        It takes an Int and returns a function that takes an Int and returns an Int.
        Example: chooseProtocol(for: 30)(30) — the first call returns coolDown,
        the second call applies it to 30 and gives 27.

     Bonus. Where does the alarm counter live after makeAlarm returns?
        The closure captures the variable count. Swift moves it out of the
        function's stack into a separate box on the heap, and the closure keeps
        a reference to that box. The counter lives as long as the closure
        (alarm) lives, so it keeps its value between calls. Every new
        makeAlarm(...) call creates its own separate counter.
    */

