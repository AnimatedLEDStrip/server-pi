import com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar
import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

tasks.wrapper {
    gradleVersion = "7.4.2"
}

plugins {
    kotlin("jvm") version "1.7.20"
    id("com.github.johnrengelman.shadow") version "6.1.0"
}

repositories {
    mavenCentral()
    mavenLocal()
}

group = "io.github.animatedledstrip"
version = "1.0"
description = "An AnimatedLEDStrip server for Raspberry Pis"

val animatedledstripServerVersion: String? by project
val animatedledstripPiVersion: String? by project
val alsServerVersion = animatedledstripServerVersion ?: "1.2.0-SNAPSHOT"
//val alsPiVersion = animatedledstripPiVersion ?: "1.0.2-SNAPSHOT"

sourceSets.main {
    dependencies {
//        implementation("io.github.animatedledstrip:animatedledstrip-pi:$alsPiVersion")
        implementation("io.github.animatedledstrip:animatedledstrip-server-jvm:$alsServerVersion")
        implementation("com.github.mbelling:rpi-ws281x-java:2.0.0-SNAPSHOT")
        api("org.apache.logging.log4j:log4j-core:2.13.2")
        api("org.apache.logging.log4j:log4j-api:2.13.2")
    }

    java.srcDirs("src/main/kotlin")
}

tasks.withType<ShadowJar> {
    manifest.attributes.apply {
        put("Main-Class", "animatedledstrip.server.example.MainKt")
    }
}
dependencies {
    implementation(kotlin("stdlib-jdk8"))
}
val compileKotlin: KotlinCompile by tasks
compileKotlin.kotlinOptions {
    jvmTarget = "1.8"
}
val compileTestKotlin: KotlinCompile by tasks
compileTestKotlin.kotlinOptions {
    jvmTarget = "1.8"
}