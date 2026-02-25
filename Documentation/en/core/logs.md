# Logging

One of the key features of the library is detailed logging that helps understand what's happening and warns about potential problems.

## Configuration

### Logging Function

By default, logs are output via `print`:

```swift
print("\(logLevel): \(message)")
```

To configure your own logging function:

```swift
DISetting.Log.fun = { level, message, file, line in
    // Your logic
    MyLogger.log(level: level, message: message, file: file, line: line)
}
```

> **Important:** Logging is synchronous. In release builds, it's recommended to disable logs for performance.

### Tab Character

Logs add tabs for nested objects. By default, the tab character is used:

```swift
DISetting.Log.tab = ">>"  // Change to ">>"
```

## Log Levels

| Level | Description |
|-------|-------------|
| `error` | Critical error. The program crashed or may crash |
| `warning` | Warning about potential problems |
| `info` | Information about informational scenarios |
| `verbose` | Detailed debug information |
| `none` | Complete log disabling |

### Level Configuration

```swift
// Show all logs up to specified level inclusive
DISetting.Log.level = .verbose  // All logs
DISetting.Log.level = .warning  // error + warning
DISetting.Log.level = .none     // Disable logs
```

Default level is `.info`.

### Level Priority

```
none < error < warning < info < verbose
```

## Message Descriptions

### Fatal Error (Application Crash)

#### `Can't resolve type {type}. For more information see logs.`

**Cause:** Failed to create object for specified non-optional type.

**Solutions:**
- Make sure the type is registered
- Check previous logs for details
- Use `Optional<Type>` if object may be absent

#### `Registration with type found {type}, but the registration return nil.`

**Cause:** Creation method returned `nil`, but type is injected as non-optional.

**Solution:** Change dependency type to optional or ensure creation doesn't return `nil`.

#### `Can't cast {objtype} to {type}.`

**Cause:** Incorrect use of `.as()` during registration.

**Solution:** Verify that the class actually implements the specified protocol. Or use `.as(check:)`

#### `Please inject this property from DI in file: {file} on line: {line}.`

**Cause:** `Lazy` or `Provider` initialized empty and not injected from DI.

**Solution:** Ensure the property is injected via `.injection()`.

### Error

#### `Until get argument. Not found extensions for {Component}`

**Cause:** Component expects `arg()`, but no argument was passed during resolve.

**Solution:**
```swift
// Wrong
let obj: MyClass = container.resolve()

// Correct
let obj: MyClass = container.resolve(arg: "value")
```

See more: [Injection Modifiers](modificated_injection.md#arguments-arg)

#### `Are you using root components, but a root component was found that was not marked as root: {Component}`

**Cause:** When using root components, a resolve of non-root component was found.

**Solution:** Add `.root()` to the component or check resolve logic.

#### `Until make extensions can't find component by type: {type}`

**Cause:** Component not found for specified type during injection.

**Solution:** Register a component of the specified type.

#### `Until make extensions can't choose component by type: {type}`

**Cause:** Multiple components found for type, selection is ambiguous.

**Solution:**
- Use tags to distinguish
- Use `.default()` to specify priority
- Remove extra registrations

### Info

#### `Not found {type}`

**Cause:** Component not found for type.

**Note:** Often leads to fatal error if type is non-optional.

### Verbose (Debug)

Detailed logs about the process:
- Component registration
- Start/end of object creation
- Dependency injection
- Cache retrieval

## Configuration Recommendations

### Development

```swift
#if DEBUG
DISetting.Log.level = .verbose
DISetting.Log.fun = { level, message, file, line in
    let emoji = switch level {
        case .error: "❌"
        case .warning: "⚠️"
        case .info: "ℹ️"
        case .verbose: "🔍"
        case .none: ""
    }
    print("\(emoji) [\(level)] \(message)")
}
#endif
```

### Production

```swift
#if !DEBUG
DISetting.Log.level = .none  // Complete disabling
#endif
```

### Logger Integration

```swift
import os.log

let diLog = OSLog(subsystem: "com.app.di", category: "DITranquillity")

DISetting.Log.fun = { level, message, file, line in
    let osLogType: OSLogType = switch level {
        case .error: .fault
        case .warning: .error
        case .info: .info
        case .verbose: .debug
        case .none: .debug
    }

    os_log("%{public}@", log: diLog, type: osLogType, message)
}
```

### File Saving

```swift
DISetting.Log.fun = { level, message, file, line in
    let logEntry = "[\(Date())] [\(level)] \(file):\(line) - \(message)\n"

    if let data = logEntry.data(using: .utf8) {
        FileHandle.standardOutput.write(data)
        // Or write to file
    }
}
```

## Graph Validation Logs

When calling `checkIsValid()`, special logs about graph problems are output:
- Missing dependencies
- Ambiguous injections
- Cycle problems
- Unused components

See more: [Graph Validation](../graph/graph_validation.md)

## Debugging Complex Cases

### Enable verbose for problematic area

```swift
func debugResolve<T>(_ type: T.Type) -> T {
    let previousLevel = DISetting.Log.level
    DISetting.Log.level = .verbose

    let result: T = container.resolve()

    DISetting.Log.level = previousLevel
    return result
}
```

### Graph Analysis

```swift
let graph = container.makeGraph()

// Find unknown types
let missing = graph.vertices.compactMap { vertex -> String? in
    if case .unknown(let unknown) = vertex {
        return String(describing: unknown.type)
    }
    return nil
}

print("Missing dependencies: \(missing)")
```

## Additional Links

- [Graph Validation](../graph/graph_validation.md)
- [Getting the Graph](../graph/get_graph.md)
