import PackageDescription

let package = Package(
  name: "DITranquillity",
	targets: [
		Target(name: "Core"),
		Target(name: "Storyboard", dependencies: ["Core"]),
		Target(name: "Assembly", dependencies: ["Core"]),
  ]
)
