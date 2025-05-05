# NeuroGrid: AI Compute Resource Optimization Protocol

**Version:** 3.0  
**Smart Contract Language:** Clarity (Stacks Blockchain)  
**Purpose:** Tokenized management, allocation, and optimization of decentralized AI compute resources.

---

## 🚀 Overview

NeuroGrid is a decentralized protocol for registering, allocating, and optimizing compute resources contributed by AI researchers and infrastructure providers. The system ensures efficient compute unit distribution based on usage demand, researcher priority, and system-wide utilization thresholds.

Key features:
- Tokenized compute unit contributions by researchers
- Optimized compute resource allocation through voting and approval mechanisms
- Admin-managed compute cycles, thresholds, and energy credit pools
- Transparent tracking of resource utilization and optimization outcomes

---

## 🔐 Features

### 🛠️ Resource Management
- `register-resource`: Researchers register AI compute resources with specs and optimization requests.
- `finalize-resource`: Admin finalizes optimization based on utilization metrics.

### 👨‍🔬 Researcher Onboarding
- `register-researcher`: Researchers deposit compute tokens to join and receive a compute balance.
- Profile tracking of resources used and compute allocations.

### 📊 Compute Allocation
- `allocate-compute`: Researchers approve or reject resource optimization.
- Allocations impact the final optimization status.

### ⚙️ Admin Controls
- `activate-network` / `shutdown-network`: Toggle compute operations.
- `update-minimum-compute`: Adjust minimum compute unit requirement.
- `update-utilization-threshold`: Set required utilization for optimization.
- `advance-compute-cycle`: Progress the compute lifecycle.
- `transfer-administrator-role`: Reassign protocol admin rights.

---

## 📑 Data Structures

### `compute-resources`
Tracks AI resources including specs, usage votes, optimization requests, and availability.

### `researcher-profiles`
Manages researcher contributions, compute balances, and resource usage history.

### `allocation-records`
Stores researcher votes (approve/reject) per resource, including compute allocation weight.

---

## 🔍 Read-Only Queries

- `get-resource-details`: View metadata and status of a compute resource.
- `get-researcher-profile`: View a researcher's contribution profile.
- `get-network-metrics`: See global settings like utilization thresholds and cycle count.

---

## ⚠️ Error Codes

| Code | Description |
|------|-------------|
| `u1` | Not administrator |
| `u2` | Network is offline |
| `u3` | Invalid resource |
| `u4` | Resource already allocated |
| `u5` | Invalid parameter |
| `u6` | Insufficient compute units |
| `u7` | Resource already exists |
| `u8` | Already scheduled allocation |
| `u9` | Not authorized |

---

## ✅ Example Flow

1. Admin activates the network with `activate-network`.
2. Researchers join using `register-researcher` and deposit compute units.
3. Resources are registered via `register-resource`.
4. Community allocates compute votes using `allocate-compute`.
5. Admin finalizes optimization with `finalize-resource`.

---

## 💬 Contact

For collaboration, integration, or issues, reach out to the project maintainers or open an issue on the repository.
