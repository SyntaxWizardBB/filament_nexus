allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// NixOS: the Android SDK lives in the read-only Nix store, so missing platforms
// can't be auto-installed. firebase_auth hardcodes `compileSdkVersion 34` (not
// present — only 35/36 are). Force every Android subproject to compileSdk 35.
// Registered BEFORE `evaluationDependsOn(":app")` so afterEvaluate is still valid.
subprojects {
    afterEvaluate {
        val androidExtension = extensions.findByName("android") ?: return@afterEvaluate
        androidExtension.javaClass.methods
            .firstOrNull {
                it.name == "compileSdkVersion" &&
                    it.parameterTypes.size == 1 &&
                    (it.parameterTypes[0] == Int::class.javaPrimitiveType ||
                        it.parameterTypes[0] == Integer::class.java)
            }
            ?.invoke(androidExtension, 35)
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
