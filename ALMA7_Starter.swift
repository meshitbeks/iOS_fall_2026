// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part2_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Default to struct. Use class only where the task says so.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · The Deck Register

// 1.1
enum Deck: String, CaseIterable {
    case bridge, lab, cargo, medbay, engine   // raw values are assigned automatically: "bridge", "lab", ...

    var evacuationPriority: Int {
        switch self {          // no default: the compiler checks every case is covered
        case .bridge: return 1
        case .medbay: return 2
        case .lab:    return 3
        case .engine: return 4
        case .cargo:  return 5
        }
    }
}

print("--- Level 1.1 · Decks")
for deck in Deck.allCases {
    print("\(deck.rawValue): evacuation priority \(deck.evacuationPriority)")
}

// 1.2
enum AlarmLevel: Int {
    case green = 0, yellow, orange, red   // yellow = 1, orange = 2, red = 3 (implicit)

    static func level(forTotalMass mass: Int) -> AlarmLevel {
        let steps = min(max(mass / 500, 0), 3)    // every full 500 kg = one step, capped at red (3)
        return AlarmLevel(rawValue: steps) ?? .red
    }
}

print("--- Level 1.2 · Alarm levels")
print(AlarmLevel.level(forTotalMass: 0))      // green
print(AlarmLevel.level(forTotalMass: 940))    // yellow
print(AlarmLevel.level(forTotalMass: 4000))   // red


// MARK: Level 2 · The Manifest

// 2.1
enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}

// 2.2
func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)
    let tag = parts.first ?? ""

    switch tag {
    case "crate":
        guard parts.count == 3,
              let id = Int(parts[1]),
              let massKg = Int(parts[2])
        else { return .unknown(raw: line) }
        return .crate(id: id, massKg: massKg)

    case "container":
        guard parts.count == 3,
              let massKg = Int(parts[2])
        else { return .unknown(raw: line) }
        return .container(code: parts[1], massKg: massKg)

    case "livestock":
        guard parts.count == 4,
              let count = Int(parts[2]),
              let massPerUnitKg = Int(parts[3])
        else { return .unknown(raw: line) }
        return .livestock(species: parts[1], count: count, massPerUnitKg: massPerUnitKg)

    default:
        return .unknown(raw: line)
    }
}

// 2.3
func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case .crate(_, let massKg):
        return massKg
    case .container(_, let massKg):
        return massKg
    case .livestock(_, let count, let massPerUnitKg):
        return count * massPerUnitKg
    case .unknown:
        return 0
    }
}

print("--- Level 2 · Manifest")
var totalMass = 0
var unknownCount = 0
for line in rawManifest {
    let entry = parseEntry(line)
    print(entry, "->", mass(of: entry), "kg")
    totalMass += mass(of: entry)
    if case .unknown = entry {
        unknownCount += 1
    }
}
print("Total mass:", totalMass, "kg")
print("Unknown lines:", unknownCount)

let A = totalMass
print("A =", A)


// MARK: Level 3 · Crew Snapshots

// 3.1
struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    mutating func breathe(_ amount: Int) {
        oxygen = max(0, oxygen - amount)        // never below 0
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: name, deck: .medbay, oxygen: 100)   // a brand-new value for self
    }

    static func rookie(named name: String) -> CrewSnapshot {
        CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}

print("--- Level 3.1 · CrewSnapshot methods")
var test = CrewSnapshot.rookie(named: "Rookie")
print("Rookie:", test)
test.breathe(130)
print("After breathe(130):", test)        // oxygen 0, not negative
test.move(to: .cargo)
print("After move(to: .cargo):", test)
test.reviveInMedbay()
print("After reviveInMedbay():", test)

// 3.2
var builtRoster: [CrewSnapshot] = []
for record in crewData {
    guard let deck = Deck(rawValue: record.deck) else {
        print("WARNING: \(record.name) is on unknown deck '\(record.deck)', skipped")
        continue
    }
    builtRoster.append(CrewSnapshot(name: record.name, deck: deck, oxygen: record.oxygen))
}
let crewRoster = builtRoster

print("--- Level 3.2 · Roster")
for member in crewRoster {
    print("\(member.name) on \(member.deck.rawValue), O2 \(member.oxygen)")
}

// 3.3 · Value semantics
print("--- Level 3.3 · Value semantics")

// 1) Copy
let original = CrewSnapshot.rookie(named: "Aliya")
var copy = original
print("1) BEFORE: original.oxygen =", original.oxygen, "| copy.oxygen =", copy.oxygen)
copy.breathe(30)
print("1) AFTER:  original.oxygen =", original.oxygen, "| copy.oxygen =", copy.oxygen)

// 2) Plain parameter (the function gets its own copy)
func drainPlain(_ member: CrewSnapshot) -> Int {
    var member = member
    member.breathe(50)
    return member.oxygen
}

var subject = CrewSnapshot.rookie(named: "Bota")
print("2) BEFORE: subject.oxygen =", subject.oxygen)
let insideValue = drainPlain(subject)
print("2) AFTER:  inside function =", insideValue, "| subject.oxygen =", subject.oxygen)

// 3) inout (the function writes back into the original)
func drainInout(_ member: inout CrewSnapshot) {
    member.breathe(50)
}

print("3) BEFORE: subject.oxygen =", subject.oxygen)
drainInout(&subject)
print("3) AFTER:  subject.oxygen =", subject.oxygen)


// MARK: Level 4 · The Teleport Pod

// 4.1
// A class gets no memberwise initializer, so we write init ourselves.
// The struct in Level 3 got one for free (see defense question 1).
final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    func load(_ crew: CrewSnapshot) -> Bool {
        guard occupant == nil, chargeLevel >= 20 else {
            return false
        }
        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        guard let passenger = occupant else {
            return nil                // empty pod: no charge spent
        }
        chargeLevel -= 20
        occupant = nil
        return passenger
    }

    // Bonus 1
    deinit {
        print("TeleportPod \(id) destroyed (deinit)")
    }
}

// 4.2 · Charge ledger
func findCrew(named name: String) -> CrewSnapshot? {
    for member in crewRoster {
        if member.name == name {
            return member
        }
    }
    return nil
}

func loadAndFire(_ name: String, using pod: TeleportPod) {
    guard let member = findCrew(named: name) else {
        print("No crew member named \(name)")
        return
    }
    let loaded = pod.load(member)
    let arrived = pod.fire()
    print("\(name): loaded = \(loaded), arrived = \(arrived?.name ?? "nobody"), charge = \(pod.chargeLevel)")
}

print("--- Level 4.2 · Charge ledger")
let pod1 = TeleportPod(id: "P-1", chargeLevel: 100)
print("Start: charge =", pod1.chargeLevel)
loadAndFire("Timur", using: pod1)
loadAndFire("Dana", using: pod1)
loadAndFire("Nurlan", using: pod1)
let emptyShot = pod1.fire()
print("Empty fire: arrived = \(emptyShot?.name ?? "nobody"), charge = \(pod1.chargeLevel)")

let C = pod1.chargeLevel
print("C =", C)

// 4.3 · Reference semantics
print("--- Level 4.3 · Reference vs value")
let podX = TeleportPod(id: "X", chargeLevel: 100)
let podY = podX
print("Class BEFORE: podX =", podX.chargeLevel, "| podY =", podY.chargeLevel)
podY.chargeLevel = 30
print("Class AFTER:  podX =", podX.chargeLevel, "| podY =", podY.chargeLevel)

let snapX = CrewSnapshot.rookie(named: "Erlan")
var snapY = snapX
print("Struct BEFORE: snapX =", snapX.oxygen, "| snapY =", snapY.oxygen)
snapY.oxygen = 30
print("Struct AFTER:  snapX =", snapX.oxygen, "| snapY =", snapY.oxygen)
// Rule: assigning a class copies the reference (both names point to ONE object),
// assigning a struct copies the whole value (two independent values).


// MARK: Level 5 · Station Systems

// 5.1
final class Station {
    // Stored (let)
    let callSign: String

    // Stored (var), built from deckReadings
    var oxygenByDeck: [Deck: Int]

    // Stored (var) with observers
    var hullIntegrity: Int {
        willSet {
            print("Hull integrity: \(hullIntegrity) -> \(newValue)")
        }
        didSet {
            hullIntegrity = min(max(hullIntegrity, 0), 100)   // clamp into 0...100
        }
    }

    // Lazy stored: computed only on first access
    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        return "\(self.callSign): \(self.oxygenByDeck.count) decks, total O2 \(self.totalOxygen), hull \(self.hullIntegrity)"
    }()

    // Computed, read-only (no get keyword)
    var totalOxygen: Int {
        var sum = 0
        for (_, value) in oxygenByDeck {
            sum += value
        }
        return sum
    }

    // Computed, get + set
    var averageOxygen: Int {
        get {
            guard oxygenByDeck.isEmpty == false else { return 0 }
            return totalOxygen / oxygenByDeck.count
        }
        set {
            for deck in oxygenByDeck.keys {
                oxygenByDeck[deck] = newValue
            }
        }
    }

    init(callSign: String, readings: [(deck: String, oxygen: Int)], hullIntegrity: Int) {
        self.callSign = callSign
        var table: [Deck: Int] = [:]
        for reading in readings {
            guard let deck = Deck(rawValue: reading.deck) else {
                print("Skipping reading for unknown deck: \(reading.deck)")
                continue
            }
            table[deck] = reading.oxygen
        }
        self.oxygenByDeck = table
        self.hullIntegrity = hullIntegrity
    }
}

print("--- Level 5.1 · Station")
let station = Station(callSign: "ALMA-7", readings: deckReadings, hullIntegrity: 100)
print("Decks with readings:", station.oxygenByDeck.count)
print("Total oxygen:", station.totalOxygen)
print("Average oxygen:", station.averageOxygen)

let B = station.averageOxygen
print("B =", B)

print("Before first access to fullDiagnostics")
print(station.fullDiagnostics)     // "Running full scan..." appears here
print("Second access:")
print(station.fullDiagnostics)     // no scan message: value already stored

let quietStation = Station(callSign: "ALMA-8", readings: deckReadings, hullIntegrity: 90)
print("quietStation created, fullDiagnostics never touched -> no scan message:", quietStation.callSign)

station.averageOxygen = 70
print("After averageOxygen = 70 -> total:", station.totalOxygen, "| average:", station.averageOxygen)

// 5.2 · The clamp trap
print("--- Level 5.2 · Clamp trap")
station.hullIntegrity = 130
print("hullIntegrity =", station.hullIntegrity)    // 100
station.hullIntegrity = -40
print("hullIntegrity =", station.hullIntegrity)    // 0
station.hullIntegrity = 55
print("hullIntegrity =", station.hullIntegrity)    // 55
// Why no infinite loop: assigning a property inside its OWN didSet
// does not call willSet/didSet again. Swift writes the value directly.


// MARK: Level 6 · Incident Reports

/*
// Report 1
var roster = crewRoster
for var member in roster {
    member.oxygen -= 10
}
print(roster[0].oxygen)   // author expected the crew to have lost oxygen

// Report 2
let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = podA
podB.chargeLevel = 0
print(podA.chargeLevel)   // author expected 100

// Report 3
struct Logbook {
    var entries: [String] = []
    func add(_ entry: String) {
        entries.append(entry)
    }
}

// Report 4
let snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40

let pod = TeleportPod(id: "B", chargeLevel: 50)
pod.chargeLevel = 10
*/

/*
 REPORT 1 (compiles, wrong)
   Expected: every crew member loses 10 oxygen.
   Actual:   roster[0].oxygen is still 62. `member` is a COPY of each element;
             the copy is changed and thrown away.
   Rule:     structs are value types; for-in gives you copies.
   Fix:      change the array through its indices (see below).

 REPORT 2 (compiles, wrong)
   Expected: podA keeps 100.
   Actual:   prints 0. podB = podA copies the REFERENCE, so both names
             point to the same object.
   Rule:     classes are reference types.
   Fix:      create a separate pod (see below).

 REPORT 3 (does NOT compile)
   Error:    "Cannot use mutating member on immutable value: 'self' is immutable"
   Rule:     a struct method cannot change its properties unless it is marked `mutating`.
   Fix:      mutating func add(...)

 REPORT 4 (the snapshot line does not compile, the pod line compiles)
   snapshot.oxygen = 40 -> "Cannot assign to property: 'snapshot' is a 'let' constant"
       For a struct, `let` freezes the WHOLE value, including all its properties.
   pod.chargeLevel = 10 -> works.
       For a class, `let` freezes only the REFERENCE (you can't point `pod` at
       another object), but the object's var properties can still change.
   Fix:      var snapshot = ...
*/

print("--- Level 6 · Fixed versions")

// Fix 1
var fixedRoster = crewRoster
for index in fixedRoster.indices {
    fixedRoster[index].oxygen -= 10
}
print("Fix 1: fixedRoster[0].oxygen =", fixedRoster[0].oxygen, "| crewRoster[0].oxygen =", crewRoster[0].oxygen)

// Fix 2
let fixedPodA = TeleportPod(id: "A", chargeLevel: 100)
let fixedPodB = TeleportPod(id: "A-copy", chargeLevel: fixedPodA.chargeLevel)
fixedPodB.chargeLevel = 0
print("Fix 2: podA =", fixedPodA.chargeLevel, "| podB =", fixedPodB.chargeLevel)

// Fix 3
struct Logbook {
    var entries: [String] = []
    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}
var logbook = Logbook()
print("Fix 3: entries before =", logbook.entries.count)
logbook.add("Day 10: teleporter incident")
print("Fix 3: entries after =", logbook.entries)

// Fix 4
var fixedSnapshot = CrewSnapshot.rookie(named: "Dana")
fixedSnapshot.oxygen = 40
let fixedPod = TeleportPod(id: "B", chargeLevel: 50)
fixedPod.chargeLevel = 10
print("Fix 4: snapshot.oxygen =", fixedSnapshot.oxygen, "| pod.chargeLevel =", fixedPod.chargeLevel)


// MARK: Level 7 · Sealing the Black Box

final class FlightRecorder {
    // private: blocks all code outside this class from reading, replacing or clearing the list
    private var entries: [String] = []

    // private(set): blocks outside code from writing isSealed (e.g. back to false); reading is allowed
    private(set) var isSealed = false

    // internal: blocks only other modules; anyone here can READ the count (it is get-only)
    internal var entryCount: Int {
        entries.count
    }

    // internal: blocks only other modules; anyone here can READ the transcript (get-only)
    internal var transcript: String {
        var text = ""
        for (index, entry) in entries.enumerated() {
            text += "\(index + 1). \(entry)\n"
        }
        return text
    }

    // internal: blocks only other modules; adding is allowed, but rejected after sealing
    @discardableResult
    internal func add(_ entry: String) -> Bool {
        guard isSealed == false else {
            print("Recorder is sealed: entry rejected")
            return false
        }
        entries.append(entry)
        return true
    }

    // internal: blocks only other modules; anyone can seal, and there is no way to unseal
    internal func seal() {
        isSealed = true
    }

    // fileprivate: blocks code in OTHER files; auditTranscript below (same file) can use it
    fileprivate func entriesForAudit() -> [String] {
        entries        // returns a copy, so the caller can't change the real list
    }
}

func auditTranscript(of recorder: FlightRecorder) -> String {
    let all = recorder.entriesForAudit()
    return "AUDIT: \(all.count) entries, sealed = \(recorder.isSealed), last = \(all.last ?? "none")"
}

print("--- Level 7 · Flight recorder")
let recorder = FlightRecorder()
recorder.add("Teleporter installed")
recorder.add("Day 10: crew transfer reported")
print("Entries:", recorder.entryCount)
print(recorder.transcript)
recorder.seal()
recorder.add("Try to rewrite history")
print("Entries after seal:", recorder.entryCount, "| sealed:", recorder.isSealed)
print(auditTranscript(of: recorder))

// Attempts to break the recorder from outside (do not compile):
// recorder.entries = []
//   error: 'entries' is inaccessible due to 'private' protection level
// recorder.isSealed = false
//   error: cannot assign to property: 'isSealed' setter is inaccessible


// MARK: Finale · Integrity Code

let D = AlarmLevel.level(forTotalMass: A).rawValue
print("D =", D)

let integrityCode = "\(A)-\(B)-\(C)-\(D)"
print("INTEGRITY CODE: \(integrityCode)")


// MARK: Bonus

// 2. Lifetime experiment
print("--- Bonus · deinit")
var outsideRef: TeleportPod? = nil
do {
    let tempPod = TeleportPod(id: "TEMP", chargeLevel: 10)
    outsideRef = tempPod
    print("Inside do-block: two references (tempPod and outsideRef)")
}
print("After do-block: tempPod is gone, outsideRef still holds", outsideRef?.id ?? "nothing")
outsideRef = nil            // <- deinit fires on THIS line: the last reference disappears
print("After outsideRef = nil")

// 3. Identity with ===
func describeRelation(_ a: TeleportPod, _ b: TeleportPod) -> String {
    if a === b {
        return "same pod (one object, two references)"
    }
    if a.id == b.id && a.chargeLevel == b.chargeLevel && a.occupant?.name == b.occupant?.name {
        return "two different pods with equal contents"
    }
    return "two different pods with different contents"
}

let sameRef = pod1
let twin = TeleportPod(id: "P-1", chargeLevel: pod1.chargeLevel)
print("pod1 vs sameRef:", describeRelation(pod1, sameRef))
print("pod1 vs twin:", describeRelation(pod1, twin))
print("pod1 vs podX:", describeRelation(pod1, podX))


// MARK: - ================= DEFENSE QUESTIONS =================
/*
 1. Why did CrewSnapshot get an initializer for free and TeleportPod did not?
    Swift automatically creates a memberwise init for structs:
    CrewSnapshot(name:deck:oxygen:). Classes never get one, because of
    inheritance: a subclass would also need to initialize the parent's
    properties, so Swift makes you write init yourself.

 2. What does `mutating` do to self, and why do classes never need it?
    In a struct, self is a value. `mutating` makes self an inout
    parameter, so the method can change properties or even replace self
    completely (self = CrewSnapshot(...) in reviveInMedbay). In a class,
    self is a reference to an object; changing a property changes the
    object, not the reference, so no keyword is needed.

 3. In Report 4 both values are `let`. What does `let` freeze?
    Struct: the whole value, every property inside it.
        let snapshot = ...; snapshot.oxygen = 40   // error
    Class: only the reference (which object the name points to).
        let pod = ...; pod.chargeLevel = 10        // OK
        pod = TeleportPod(...)                     // error

 4. Why must a lazy property be var? When does lazy change behaviour?
    A let must have its value when init finishes. A lazy property gets its
    value later, on first access, so it changes after init and must be var.
    Behaviour changes when the initializer has a side effect: in fullDiagnostics
    "Running full scan..." prints only on first access and never if the property
    is not used (quietStation). Also, the value is computed at first access, so
    it uses the data that exists at that moment, not at init time.

 5. private vs fileprivate in FlightRecorder:
    auditTranscript(of:) is a free function outside the class, but in the same
    file. It needs the full entry list. If the helper were private, only code
    inside FlightRecorder could call it and the audit would not compile.
    fileprivate opens it to this file only, while other files are still blocked.

 Bonus. Where does deinit fire, and why can't === be used on CrewSnapshot?
    deinit fires on `outsideRef = nil`, not at the end of the do-block.
    Leaving the block removes only tempPod; outsideRef still holds the object,
    so its reference count is 1. Setting outsideRef to nil drops it to 0, and
    ARC destroys the object immediately.
    === compares object identity (the same object in memory). It only works
    for class instances (AnyObject). A struct has no identity: every copy is
    an independent value, so there is nothing to compare. For structs you
    compare contents (==), not identity.
*/
