import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar

tasks.wrapper {
    gradleVersion = "6.7.1"
}

plugins {
    kotlin("jvm") version "1.4.21"
    id("com.github.johnrengelman.shadow") version "2.0.4"
}

repositories {
    jcenter()
    mavenCentral()
    mavenLocal()
}

group = "io.github.animatedledstrip"
version = "1.0"
description = "A library for creating an AnimatedLEDStrip server"

val animatedledstripVersion: String by project

sourceSets.main {
    dependencies {
        implementation("io.github.animatedledstrip:animatedledstrip-pi:$animatedledstripVersion")
        implementation("io.github.animatedledstrip:animatedledstrip-server-jvm:$animatedledstripVersion")
    }

    java.srcDirs("src/main/kotlin")
}

tasks.withType<ShadowJar> {
    manifest.attributes.apply {
        put("Main-Class", "animatedledstrip.server.example.MainKt")
    }
}
