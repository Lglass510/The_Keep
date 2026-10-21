[← Back to The Realm](https://github.com/Lglass510)

# The Keep

> **The stronghold where The Realm's systems live.**

The Keep is The Realm's on-premises infrastructure and systems administration repository. It documents the MavLab environment: Hyper-V, Windows Server, Active Directory, DNS, Linux administration, and the machines that make the lab a functioning environment.

Its current foundation is the `172.16.10.0/24` Hyper-V network containing `DC1`, `SRV2`, and `Linux1`.

## Evolution

The Keep will evolve from build notes into a durable systems record: current topology, service ownership, configuration state, recovery procedures, and troubleshooting history. It is the operational counterpart to The Roads' network work and The Forge's automation.

---

## MavLab

**Hands-on Infrastructure & Cloud Administration Lab**

MavLab is my personal infrastructure lab for building, breaking, troubleshooting, and documenting Windows, Linux, networking, and cloud environments.

I'm using the lab to move beyond simply knowing commands or following tutorials. I want to understand **what is happening underneath the GUI, why systems behave the way they do, and how the different pieces of an environment connect to each other.**

When something breaks, that's usually where the useful learning starts.

---

## Lab Philosophy

**Build → Break → Troubleshoot → Understand → Automate**

I use MavLab to practice the same process I'd use in a real infrastructure environment:

* Build and configure systems
* Test how they interact
* Break things intentionally or troubleshoot unexpected failures
* Isolate the problem
* Identify the root cause
* Document the resolution
* Automate repeatable tasks where it makes sense

The goal isn't just to make something work. **It's to understand why it works.**

---

## 🌟 Featured Project: Hyper-V NAT & Virtual Network Lab

The most in-depth writeup in this repo — a full build-and-troubleshoot case study covering Hyper-V virtual switching, Windows NAT, and a layered connectivity failure that took real diagnosis to untangle (ICMP failing while TCP/DNS still worked, a missing default gateway on the domain controller, and a DNS forwarder issue underneath it all).

* Built a custom Hyper-V virtual switch and NAT gateway from scratch to get an isolated `172.16.10.0/24` lab talking to the internet
* Diagnosed connectivity layer by layer — local gateway → internet → DNS — instead of assuming a single failed `ping` meant everything was broken
* Traced and fixed a DNS forwarder issue and a missing default gateway on the domain controller
* Documented every step with 13 screenshots and the full command history

**[→ Read the full writeup](./Networking/Hyper-V-NAT-Gateway/)**

![NAT configuration verification](./Networking/Hyper-V-NAT-Gateway/screenshots/get-netnat.png)

## 🌟 Featured Project: Active Directory Bulk Onboarding

Help-desk-style account provisioning, done with PowerShell instead of clicks: a 206-record new-hire CSV turned into AD accounts placed in the right department OU, linked to one of 10 managers through the `Manager` attribute, and added to `Contractor` and `Remote` groups based on CSV flags. Built and tested one record at a time before the full run, with a duplicate check that skips existing accounts.

**[→ Read the write-up](./ActiveDirectory/README.md)**

---

## Current Environment

MavLab currently uses a virtualized infrastructure environment built with **Hyper-V**.

### Network

```text
Network: 172.16.10.0/24
```

| System | Role                               |     IP Address |
| ------ | ---------------------------------- | -------------: |
| DC1    | Windows Server / Domain Controller | `172.16.10.10` |
| SRV2   | Windows Server / Member Server     | `172.16.10.20` |
| Linux1 | Ubuntu Linux                       | `172.16.10.30` |

The environment is designed to give me a place to practice infrastructure administration across multiple systems rather than working with isolated machines.

---

# Infrastructure Areas

## Active Directory

Building and administering a Windows domain environment with:

* Active Directory Domain Services (AD DS)
* Domain Controllers
* Users and Groups
* Organizational Units
* DNS
* Authentication and Authorization
* PowerShell administration

Not written up here yet: Group Policy, forest trusts, selective authentication.

### Documentation

* [Active Directory Domain Build](./ActiveDirectory/domain-build.md)
* [Bulk Employee Onboarding with PowerShell](./ActiveDirectory/README.md): 206-record CSV, 10 managers, 5 department OUs, `Contractor` and `Remote` groups, with the [script](./ActiveDirectory/scripts/Invoke-EmployeeOnboarding.ps1)
* [50 Users and 5 Security Groups](./ActiveDirectory/ad-lab-50-users-5-groups.md) (evidence pending)
* [ReaperSOC: SSH from Rocky Linux to the domain controller](./ReaperSOC/README.md)

---

## Networking

Practicing the fundamentals that connect the rest of the environment:

* TCP/IP
* IP addressing
* DNS
* DHCP
* Network connectivity
* Hyper-V virtual networking
* Network troubleshooting
* Windows networking tools

### Documentation

* [Hyper-V NAT Gateway](./Networking/Hyper-V-NAT-Gateway/) — featured project, see above
* [Network Build & Troubleshooting](./Networking/network-build.md)

---

## Windows Server

Building practical experience administering Windows Server across both GUI and command-line environments.

Areas include:

* Windows Server deployment
* Server Core
* PowerShell administration
* Active Directory
* DNS
* Group Policy
* Storage
* Remote administration
* Troubleshooting

### Documentation

* [Server Core Deployment](./ServerCore/srv2-deployment.md)
* [DC1 Vulnerability Assessment](./VulnerabilityAssessment/README.md): nmap from Kali, then patch-level investigation from the inside

---

## Linux

Using Ubuntu alongside the Windows infrastructure to build familiarity with Linux administration and mixed operating system environments.

### Documentation

* [Linux Networking](./Ubuntu-Server/linux-networking.md)

---

# PowerShell & Automation

PowerShell is becoming a core part of how I administer the lab.

I'm using it to:

* Configure Windows Server
* Administer Active Directory
* Query system information
* Troubleshoot infrastructure
* Manage users and groups
* Automate repetitive tasks
* Reduce manual configuration

I'm intentionally learning PowerShell beyond individual commands by understanding **objects, properties, methods, parameters, pipelines, providers, and how PowerShell interacts with the systems underneath it.**

---

# Azure & Infrastructure as Code

The Azure side of the lab lives in its own repositories:

* [The Sky Hold](https://github.com/Lglass510/The_Sky_Hold): VNets, subnets, NSGs and storage hardening with Az PowerShell and Azure CLI
* [The Ward](https://github.com/Lglass510/The_Ward_Sentinel_Soar): Microsoft Sentinel detection and automated response for Entra ID privilege escalation
* [The Ascent](https://github.com/Lglass510/The_Ascent_Bicep_Sentinel): The Ward rebuilt from code with Bicep

Areas covered across them:

* Microsoft Azure
* Microsoft Entra ID
* Azure RBAC
* Azure Virtual Networks
* Subnets
* Network Security Groups
* Azure Virtual Machines
* Azure Storage
* Azure CLI
* Azure PowerShell
* Bicep
* Infrastructure as Code

The goal is to move from manually configuring resources to **building repeatable infrastructure through code.**

---

# Troubleshooting

One of the main purposes of MavLab is troubleshooting.

Rather than documenting only successful configurations, I'm also documenting problems I encounter and how I work through them.

My troubleshooting process generally follows:

```text
Problem
   ↓
Observe
   ↓
Gather Evidence
   ↓
Form a Hypothesis
   ↓
Test
   ↓
Isolate the Fault
   ↓
Identify Root Cause
   ↓
Fix
   ↓
Verify
   ↓
Document
```

Future troubleshooting case studies will cover areas such as:

* Active Directory
* DNS
* Networking
* Windows Server
* PowerShell
* Virtualization
* Storage
* Azure

---

# Technology Stack

**Operating Systems**

* Windows 10/11
* Windows Server
* Ubuntu Linux

**Microsoft Infrastructure**

* Active Directory Domain Services
* DNS
* Group Policy
* Hyper-V

Practiced in MSSA Server and Cloud Administration course labs, not written up here: Windows Server Failover Clustering, iSCSI, MPIO, Data Deduplication.

**Cloud**

* Microsoft Azure
* Microsoft Entra ID
* Azure RBAC
* Azure Virtual Networks
* Azure Virtual Machines
* Azure Storage

**Automation & Infrastructure as Code**

* PowerShell
* Azure CLI
* Bicep

**Tools**

* Git
* GitHub
* VS Code
* IntelliJ IDEA
* Jira

---

# What I'm Learning Next

MavLab is an evolving project.

My current focus is moving deeper into **Azure, PowerShell automation, and Infrastructure as Code**, while continuing to strengthen my Windows Server and networking fundamentals.

The long-term goal is to be able to:

**Build → Administer → Troubleshoot → Automate → Explain**

the infrastructure I'm responsible for.

---

## Why I'm Building This

I'm transitioning from a U.S. Army technical background into infrastructure and cloud administration.

I enjoy the part of technology where you have to dig.

Something doesn't work.

You don't immediately know why.

So you start pulling on the thread — checking the configuration, testing connectivity, looking at logs, questioning your assumptions, and figuring out how the pieces fit together.

That's what MavLab is for.

**Not just learning where the button is, but understanding what happens when you press it.**
