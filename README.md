# AWS Infrastructure: ECS EC2 & Lambda Cronjob

Proyek ini berisi infrastruktur berbasis kode (IaC) menggunakan **Terraform** untuk membangun ekosistem AWS yang terdiri dari ECS di atas EC2, Database RDS MySQL, dan Lambda Function yang dipicu oleh EventBridge (Cronjob).

## 🏗️ Arsitektur Infrastruktur

Proyek ini akan membangun:
- **Networking**: VPC dengan subnet publik, Internet Gateway, dan Route Table.
- **Compute (ECS on EC2)**: Cluster ECS yang berjalan di atas Auto Scaling Group (ASG) instans EC2.
- **Database**: Amazon RDS MySQL Instance.
- **Serverless Automation**: AWS Lambda yang dipicu setiap 5 menit oleh EventBridge untuk melakukan input data ke RDS.
- **CI/CD**: GitHub Actions untuk otomatisasi deploy kode Lambda saat ada perubahan di folder `src/`.

## 📂 Struktur Folder
```text
.
├── .github/workflows/
│   └── deploy.yml         # CI/CD Workflow GitHub Actions
├── src/
│   └── index.py           # Script Python Lambda (Logic DB)
├── main.tf                # Provider & Networking
├── security.tf            # IAM Roles & Security Groups
├── ecs_ec2.tf             # ECS & Auto Scaling Group
├── rds.tf                 # Database RDS Configuration
├── lambda_cron.tf         # Lambda & EventBridge Scheduler
└── .gitignore             # File yang diabaikan Git
🚀 Cara Memulai
1. Persiapan Lokal
Pastikan Anda memiliki:

Terraform terinstall.

AWS CLI terkonfigurasi dengan kredensial yang memiliki izin memadai.

Python 3.9 (opsional untuk testing lokal).

2. Inisialisasi Project
Jalankan perintah berikut untuk mendownload provider AWS:

Bash
terraform init
3. Deploy Infrastruktur
Verifikasi rencana perubahan dan jalankan deployment:

Bash
terraform plan
terraform apply
4. Setup CI/CD (GitHub Actions)
Agar setiap perubahan kode di folder src/ terupdate otomatis ke AWS:

Push project ini ke repositori GitHub.

Masuk ke Settings > Secrets and variables > Actions.

Tambahkan Secrets berikut:

AWS_ACCESS_KEY_ID: Access Key dari user IAM.

AWS_SECRET_ACCESS_KEY: Secret Access Key dari user IAM.

🛠️ Update Kode Lambda
Untuk mengubah logika pengiriman data ke database, cukup edit file src/index.py, lalu lakukan git push. GitHub Actions akan secara otomatis membungkus kode menjadi .zip dan mengunggahnya ke AWS Lambda.