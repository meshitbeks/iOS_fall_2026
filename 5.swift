// =============================================================
//  Station ALMA-7, Part III: The Repair Fleet
//  iOS Mobile Development · Module 5 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part3_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section. LegacyBeacon in
//     particular must be reached with an extension, not edited.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • The Health Rule must exist in exactly ONE place in this file.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Drone records recovered from the fleet registry.
/// One `kind` does not correspond to any drone type you will build.
let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

/// Hull sensors. These are NOT drones — they never move and never work a shift.
let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

/// Hardware from the original station. You may not add anything to this
/// declaration — no methods, no protocols, no properties.
struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · The Power Cell

// Why a class and not a struct here? -> A battery is ONE physical object shared
// by its drone, so every change must hit the same battery instead of a silent copy.
final class PowerCell: Rechargeable {
    // private: blocks any code outside PowerCell from reading or setting charge
    private var charge: Int

    init(charge: Int) {
        self.charge = min(max(charge, 0), 100)     // clamp into 0...100
    }

    func level() -> Int {
        charge
    }

    func spend(_ amount: Int) -> Bool {
        guard amount > 0, amount <= charge else {
            return false                            // nothing changes
        }
        charge -= amount
        return true
    }

    func recharge(by amount: Int) {
        charge = rechargedLevel(from: charge, adding: amount)   // rule lives in Rechargeable extension
    }
}

print("--- Level 1 · PowerCell")
let testCell = PowerCell(charge: 150)
print("PowerCell(charge: 150) ->", testCell.level())
print("PowerCell(charge: -20) ->", PowerCell(charge: -20).level())
print("spend(30):", testCell.spend(30), "| level:", testCell.level())
print("spend(0):", testCell.spend(0), "| level:", testCell.level())
print("spend(500):", testCell.spend(500), "| level:", testCell.level())
testCell.recharge(by: -10)
print("recharge(by: -10) | level:", testCell.level())
testCell.recharge(by: 80)
print("recharge(by: 80) | level:", testCell.level())

// Encapsulation proof:
// testCell.charge = 100
// error: 'charge' is inaccessible due to 'private' protection level


// MARK: Level 2 · The Fleet

// 2.1
class Drone {
    let id: String
    let cell: PowerCell

    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }

    var powerCost: Int { 10 }

    var statusLine: String {
        "\(id): \(cell.level())% \(cell.level().powerBar)"
    }

    func performTask() -> Int { 0 }

    var canWorkAgain: Bool {
        cell.level() >= powerCost
    }

    // What does `final` buy you? -> No subclass can replace the ritual,
    // so NO drone can ever work without paying its powerCost first.
    final func runOnce() -> Int {
        guard cell.spend(powerCost) else {
            return 0
        }
        return performTask()
    }
}

// 2.2
final class WelderDrone: Drone {
    override var powerCost: Int { 25 }
    override func performTask() -> Int { 40 }

    func weldSeam() -> String {
        "\(id): seam welded"
    }
}

class ScannerDrone: Drone {
    // powerCost 10 is inherited from Drone, no override needed
    override func performTask() -> Int { 15 }

    override var statusLine: String {
        super.statusLine + " [scanner]"     // reuse the parent's string, don't rebuild it
    }
}

final class CargoDrone: Drone {
    override var powerCost: Int { 20 }
    override func performTask() -> Int { 25 }
}

// 2.3
func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)
    switch kind {
    case "welder":  return WelderDrone(id: id, cell: cell)
    case "scanner": return ScannerDrone(id: id, cell: cell)
    case "cargo":   return CargoDrone(id: id, cell: cell)
    default:        return nil
    }
}

var builtFleet: [Drone] = []
for record in fleetData {
    guard let drone = makeDrone(kind: record.kind, id: record.id, charge: record.charge) else {
        print("WARNING: unknown drone kind '\(record.kind)' (\(record.id)), skipped")
        continue
    }
    builtFleet.append(drone)
}
let fleet: [Drone] = builtFleet

print("--- Level 2 · Fleet before the shift")
for drone in fleet {
    print(drone.statusLine, "| cost:", drone.powerCost)
}


// MARK: Level 3 · The Shift

func runShift(_ fleet: [Drone], rounds: Int) -> Int {
    guard rounds > 0 else { return 0 }
    var total = 0
    for _ in 1...rounds {
        for drone in fleet {
            total += drone.runOnce()     // same call, different behaviour per drone
        }
    }
    return total
}

print("--- Level 3 · Shift (3 rounds)")
let A = runShift(fleet, rounds: 3)

var chargeSum = 0
var readyCount = 0
for drone in fleet {
    print(drone.statusLine)
    chargeSum += drone.cell.level()
    if drone.canWorkAgain {
        readyCount += 1
    }
}
print("Drones ready for one more task:", readyCount)

let B = chargeSum
let C = readyCount
print("A =", A, "| B =", B, "| C =", C)


// MARK: Level 4 · Diagnostics

// 4.1
protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}

// 4.2
protocol Rechargeable {
    mutating func recharge(by amount: Int)
}

// Why does Drone implement recharge(by:) without `mutating`? -> Drone is a class,
// self is a reference; we change the battery it points to, not the reference itself.
extension Drone: Diagnosable, Rechargeable {
    var componentID: String { id }
    var statusCode: Int { healthCode(for: cell.level()) }

    func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct SensorModule: Diagnosable, Rechargeable {
    let id: String
    var chargeLevel: Int

    var componentID: String { id }
    var statusCode: Int { healthCode(for: chargeLevel) }

    // struct: changing chargeLevel changes self, so `mutating` is required
    mutating func recharge(by amount: Int) {
        chargeLevel = rechargedLevel(from: chargeLevel, adding: amount)
    }
}

var builtSensors: [SensorModule] = []
for record in sensorData {
    builtSensors.append(SensorModule(id: record.id, chargeLevel: record.charge))
}
let sensors = builtSensors

// Recharge demo on TEST objects, so the real fleet/sensors (and D) are untouched
print("--- Level 4 · Rechargeable")
let testDrone = CargoDrone(id: "TEST-C", cell: PowerCell(charge: 10))
print("Test drone before:", testDrone.cell.level())
testDrone.recharge(by: 50)
print("Test drone after recharge(by: 50):", testDrone.cell.level())

var testSensor = SensorModule(id: "TEST-S", chargeLevel: 90)
print("Test sensor before:", testSensor.chargeLevel)
testSensor.recharge(by: 50)
print("Test sensor after recharge(by: 50):", testSensor.chargeLevel)   // 100, capped

// 4.3
func diagnosticsReport(_ components: [Diagnosable]) -> String {
    var report = "=== DIAGNOSTICS (\(components.count) components) ===\n"
    for component in components {
        report += component.diagnose() + "\n"
    }
    return report
}

// Why could [Drone] never have held the sensors? -> SensorModule is a struct,
// and a struct cannot inherit from a class; the protocol is the only common type they share.
var components: [Diagnosable] = []
for drone in fleet {
    components.append(drone)
}
for sensor in sensors {
    components.append(sensor)
}

print("--- Level 4 · Report: drones + sensors")
print(diagnosticsReport(components))


// MARK: Level 5 · Shared Behaviour

// 5.1
extension Diagnosable {
    func diagnose() -> String {
        "\(componentID): code \(statusCode)"
    }

    // THE HEALTH RULE. The only place in the file where 20 and 50 appear.
    func healthCode(for level: Int) -> Int {
        if level < 20 { return 2 }      // critical
        if level < 50 { return 1 }      // warning
        return 0                        // nominal
    }
}

// The recharge rule, also written once (used by PowerCell and SensorModule)
extension Rechargeable {
    func rechargedLevel(from current: Int, adding amount: Int) -> Int {
        guard amount > 0 else { return current }
        return min(current + amount, 100)
    }
}

// 5.2
extension LegacyBeacon: Diagnosable {
    var componentID: String { name }
    var statusCode: Int { healthCode(for: signalStrength) }

    func diagnose() -> String {
        "*** LEGACY HARDWARE *** \(componentID): signal \(signalStrength), code \(statusCode)"
    }
}

components.append(beacon)

print("--- Level 5 · Report: drones + sensors + beacon")
print(diagnosticsReport(components))

var codeSum = 0
for component in components {
    codeSum += component.statusCode
}
let D = codeSum
print("D =", D)

// 5.3
extension Int {
    var powerBar: String {
        let filled = Swift.min(Swift.max(self / 10, 0), 10)
        return String(repeating: "#", count: filled) + String(repeating: ".", count: 10 - filled)
    }
}

print("--- Level 5.3 · powerBar")
print("42 ->", 42.powerBar)
print("-5 ->", (-5).powerBar)
print("250 ->", 250.powerBar)


// MARK: Level 6 · Incident Reports
// Two of these do not compile. Two compile and lie.
// For each: expectation, actual behaviour, the language rule, the fix.

/*
// Report 1
class PatchDrone: Drone {
    func performTask() -> Int {
        return 30
    }
}

// Report 2
final class HeavyWelder: WelderDrone {
    override func runOnce() -> Int {
        return 999
    }
}

// Report 3
let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let first = reportFleet[0]
print(first.weldSeam())

// Report 4
protocol Labelled {
    var componentID: String { get }
}

extension Labelled {
    func label() -> String { "generic component" }
}

struct Thruster: Labelled {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}

let parts: [Labelled] = [Thruster(componentID: "T-1")]
print(parts[0].label())
*/

/*
 REPORT 1 — does NOT compile
   Expected: PatchDrone produces 30 work units.
   Actual:   error: overriding declaration requires an 'override' keyword
   Rule:     replacing a parent's method must be marked `override`,
             so you can never override something by accident.
   Fix:      override func performTask() -> Int

 REPORT 2 — does NOT compile
   Expected: a welder that always returns 999.
   Actual:   error: inheritance from a final class 'WelderDrone'
             (and runOnce is final too: instance method overrides a 'final' instance method)
   Rule:     a final class cannot have subclasses, a final method cannot be overridden.
   Fix:      inherit from Drone and change only cost and work;
             the ritual (pay first, then work) stays.

 REPORT 3 — does NOT compile
   Expected: call weldSeam() on the first drone.
   Actual:   error: value of type 'Drone' has no member 'weldSeam'
   Rule:     the compiler only knows the declared type (Drone), not what is inside at runtime.
   Fix:      if let welder = first as? WelderDrone { ... }
             as? returns an optional because the cast can fail: the drone
             might be a scanner, and then the answer is nil.

 REPORT 4 — compiles and lies
   Expected: "thruster T-1"
   Actual:   "generic component"
   Rule:     label() is NOT in the protocol, it only exists in the extension.
             When the value's type is Labelled, Swift picks the method statically
             from the extension and never looks at Thruster's own version.
   Fix:      add `func label() -> String` to the protocol (one line).
*/

print("--- Level 6 · Fixed versions")

// Fix 1
class PatchDrone: Drone {
    override func performTask() -> Int {
        return 30
    }
}
let patch = PatchDrone(id: "PT-1", cell: PowerCell(charge: 100))
print("Fix 1: PatchDrone.runOnce() =", patch.runOnce())

// Fix 2
final class HeavyWelder: Drone {
    override var powerCost: Int { 40 }
    override func performTask() -> Int { 80 }
}
let heavy = HeavyWelder(id: "HW-1", cell: PowerCell(charge: 30))
print("Fix 2: HeavyWelder with 30% charge ->", heavy.runOnce(), "(not enough power, no work)")

// Fix 3
let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let firstDrone = reportFleet[0]
if let welder = firstDrone as? WelderDrone {
    print("Fix 3:", welder.weldSeam())
}

// Fix 4
protocol Labelled {
    var componentID: String { get }
    func label() -> String          // <- the one line that changes the output
}
extension Labelled {
    func label() -> String { "generic component" }
}
struct Thruster: Labelled {
    let componentID: String
    func label() -> String { "thruster \(componentID)" }
}
let parts: [Labelled] = [Thruster(componentID: "T-1")]
print("Fix 4:", parts[0].label())


// MARK: Finale · Mission Code

let missionCode = "\(A)-\(B)-\(C)-\(D)"
print("MISSION CODE: \(missionCode)")


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why does a class satisfy a `mutating` protocol requirement without the
    keyword, while a struct must write it?
    `mutating` means "this method may change self". For a class, self is a
    reference; recharge changes the battery object, not the reference, so a
    normal method is enough (and `mutating` is not even allowed in classes).
    For a struct, chargeLevel lives INSIDE the value, so changing it changes
    self, and without `mutating` the compiler says self is immutable.

 2. One thing inheritance does that protocols cannot, and one thing
    protocols do that inheritance cannot:
    Inheritance shares STORED properties and a ready init (id, cell) and lets
    a subclass call super. A protocol cannot store data.
    A protocol works for structs, enums and types I can't edit (LegacyBeacon
    via extension), and a type can adopt many protocols but only one superclass.

 3. What does `final` prevent, and what did it protect in runOnce()?
    On a class it forbids subclasses, on a method it forbids override.
    Making runOnce() final means no drone can skip paying powerCost
    (like HeavyWelder returning 999 for free): the "pay, then work" rule
    is guaranteed for every drone, present and future.

 4. In Report 4, why did the protocol extension's method win?
    label() was only in the extension, not a protocol requirement. For a value
    typed as Labelled, Swift decides at compile time and uses the extension's
    version. Methods listed IN the protocol are chosen at runtime by the real
    type, so adding label() to the protocol makes Thruster's version win.
*/
