# FlutterServiceManagment

📌 Descrição

Esse projeto tem como objetivo um aplicativo desenvolvido em Flutter para gerenciar atendimentos/serviços. Ele permite criar, listar, atualizar, remover logicamente e executar atendimentos, oferecendo uma solução simples e multiplataforma para controle de ordens de serviço, tarefas ou chamados.

📁 Tree Structure
flutterServiceManagment/
├── android/                
├── ios/                    
├── linux/                  
├── macos/                  
├── windows/                
├── web/                    
├── lib/ 
├   ├──────📁---core
├   ├──────📁---data
├   ├       ├── 📁---datasource
├   ├       ├── 📁---repository
├   ├───────📁---domain
├   ├       ├── 📁---contract
├   ├       ├── 📁---entity
├   ├       ├── 📁---usecases
├   ├───────📁---presentation
├   ├       ├──  📁---cubits
├   ├       ├──  📁---pages
├   ├───────📄---main.go        
├── test/                  
├── analysis_options.yaml 
├── pubspec.yaml           
└── README.md               

⚙️ Funcionalidades

- 📋 Listar atendimentos
- ➕ Criar novo atendimento
✏️ Atualizar atendimento existente
-🗑️ Remoção lógica (soft delete) -> Encerrar atendimento
-✅ Marcar atendimento como executado

🛠 Tecnologias e Frameworks Utilizados

- Flutter (framework principal)
- Dart (linguagem)
- SDKs específicos de cada plataforma (Android/iOS/Web/Desktop)

- Dependências adicionais configuradas em pubspec.yaml

 - flutter_bloc -> Gerência de estado (Cubit)
 - sqflite -> Banco de dados local
 - image_picker -> Captura ou seleção de imagem
 - get_it -> Injeção de dependência
 - injectable -> Configuração automatizada de DI
 - build_runner -> Geração de código
 - injectable_generator ->Suporte para geração de injeção

💻 Requisitos para rodar o projeto

Antes de iniciar, certifique-se de ter:

✅ Git instalado

✅ Flutter SDK instalado e configurado

✅ Android Studio ou Visual Studio Code (recomendado)

▶️ Como rodar o projeto em qualquer máquina

Clonar o repositório

1- git clone https://github.com/EduardoSrt1/flutterServiceManagment.git
cd flutterServiceManagment

2 - Instalar dependências

flutter pub get

3 - Executar o projeto

flutter run

# Autor

😎 EduardoSrt1

# DISCLAIMER

**Esse é um projeto escolar, sem objetivos lucrativos, utilitários para corporações ou qualquer outro fim. 