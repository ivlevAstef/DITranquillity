# Glossary

This page will help you better understand the terms used in DITranquillity library documentation.

## Basic Concepts

### DI Container

The main library object (`DIContainer`) for registering components and creating class instances.

### Component

A set of metadata describing how to create an object: type, initializer, lifetime, alternative types, etc.

### [Registration](core/registration_and_service.md)

Code describing how to create an object. Components are created during registration.

### Dependency

A contract between objects: to create one object, others must be created.

### [Injection](core/injection.md)

The process of passing dependencies into an object during or after its creation.

### Resolve

The process of obtaining an object from the container (synchronous or asynchronous).

## Components and Registration

### [Root Component](core/registration_and_service.md#root-component)

A component marked with `.root()`, indicating an entry point into the dependency graph. There can be multiple root components.

### Alternative Type

A type added via `.as()`, allowing to obtain a component by protocol or base class.

### Priority

Component level (`default` or `test`), determining which component will be selected when multiple candidates exist.

## [Lifetime](core/scope_and_lifetime.md)

The period from instance creation to its destruction.

Options:
* prototype - New instance on each request (default)
* objectGraph - Single instance within one object graph
* perContainer - Single instance per container (singleton within container)
* perRun - Single instance per application run
* single - Global singleton, shared across all containers
* custom - Custom lifetime via `DIScope`

### [DIScope](core/scope_and_lifetime.md#custom-lifetime)

A class for creating custom scopes.

## Modularity

### [Part (DIPart)](core/modular.md#part)

A protocol for grouping related registrations.

### [Framework (DIFramework)](core/modular.md#framework)

A protocol for combining multiple parts into a module.

## [Modifiers](core/modificated_injection.md) and Special Types

Functions (`by(tag:on:)`, `many()`, `arg()`) for changing injection behavior.

Options:
* by(tag:) - Marker for filtering components during resolve
* many() - Modifier for getting all implementations of a type as an array
* arg() - Modifier for passing an argument during resolve

## Delayed Injection

### [Lazy](core/delayed_injection.md#lazy)

A wrapper for lazy object creation on first access.

### [Provider](core/delayed_injection.md#provider)

A factory for creating new instances on demand.

### AsyncLazy

Asynchronous version of Lazy for Swift Concurrency.

### AsyncProvider

Asynchronous version of Provider for Swift Concurrency.

## Graph API

### [DIGraph](graph/get_graph.md)

Dependency graph represented as an adjacency list.

### DIVertex

Graph vertex: component, argument, or unknown type.

### DIEdge

Graph edge describing a dependency between vertices.

### DICycle

A structure describing a found cycle in the graph.

### [Validation](graph/graph_validation.md)

Checking the graph for configuration correctness.
