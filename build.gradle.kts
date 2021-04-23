import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar

tasks.wrapper {
    gradleVersion = "6.7.1"
}

plugins {
    kotlin("jvm") version "1.4.21"
    id("com.github.johnrengelman.shadow") version "6.1.0"
}

repositories {
    jcenter()
    mavenCentral()
    mavenLocal()
}

group = "io.github.animatedledstrip"
version = "1.0"
description = "An AnimatedLEDStrip server for Raspberry Pis"

val animatedledstripServerVersion: String? by project
val animatedledstripPiVersion: String? by project
val alsServerVersion = animatedledstripServerVersion ?: "1.0.1"
val alsPiVersion = animatedledstripPiVersion ?: "1.0.1"

sourceSets.main {
    dependencies {
        implementation("io.github.animatedledstrip:animatedledstrip-pi:$alsPiVersion")
        implementation("io.github.animatedledstrip:animatedledstrip-server-jvm:$alsServerVersion")
        implementation("com.github.mbelling:rpi-ws281x-java:2.0.0-SNAPSHOT")
    }

    java.srcDirs("src/main/kotlin")
}

tasks.withType<ShadowJar> {
    manifest.attributes.apply {
        put("Main-Class", "animatedledstrip.server.example.MainKt")
    }
}
