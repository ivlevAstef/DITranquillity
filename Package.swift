import PackageDescription

let package = Package(
  name: "DITranquillity",
	targets: [
		Target(name: "Core"),
		Target(name: "Description", dependencies: ["Core"]),
		Target(name: "Component", dependencies: ["Core"]),
		Target(name: "Module", dependencies: ["Core", "Component"]),
		Target(name: "Storyboard", dependencies: ["Core"]),
		Target(name: "RuntimeArgs", dependencies: ["Core"]),
		Target(name: "Scan", dependencies: ["Core", "Component", "Module"]),
  ]
)
