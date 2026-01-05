# 📱 PostsMedia

> Aplicativo iOS desenvolvido com SwiftUI que consome dados da API JSONPlaceholder, demonstrando arquitetura MVVM, integração com APIs REST e persistência local.

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-blue.svg)](https://developer.apple.com/xcode/swiftui/)
[![iOS](https://img.shields.io/badge/iOS-17.0+-lightgrey.svg)](https://www.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## ✨ Features

- 🏠 **Feed de Posts** - Visualização de posts em grid responsivo
- 💾 **Salvar Posts** - Persistência local com SwiftData
- 👤 **Perfil de Usuário** - Detalhes completos do usuário e tarefas
- 💬 **Comentários** - Visualização de comentários por post
- 🔄 **Loading States** - Skeleton views animados
- 🎨 **UI Moderna** - Animações suaves e feedback visual
- 📤 **Compartilhamento** - ShareLink nativo do iOS

---

## 🏗️ Arquitetura

O projeto segue o padrão **MVVM** (Model-View-ViewModel) com separação clara de responsabilidades:

```
PostsMedia/
├── models/          # Modelos de dados
├── views/           # Views SwiftUI organizadas por feature
├── viewModels/      # ViewModels com lógica de negócio
└── utilities/       # Services e helpers
```

---

## 🛠️ Tecnologias

- **SwiftUI** - Interface declarativa
- **Combine** - Programação reativa
- **SwiftData** - Persistência local
- **Async/Await** - Concorrência moderna
- **URLSession** - Requisições HTTP

---

## 📋 Requisitos

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

---

## 🚀 Como Executar

1. Clone o repositório
```bash
git clone https://github.com/seu-usuario/PostsMedia.git
cd PostsMedia
```

2. Abra o projeto no Xcode
```bash
open PostsMedia.xcodeproj
```

3. Selecione um simulador ou dispositivo iOS
4. Execute o projeto (⌘ + R)

---

## 📱 Telas

### Home
Feed principal com posts em grid, loading states e empty states.

### Post Detail
Detalhes do post com comentários, opção de salvar e compartilhar.

### Saved Posts
Lista de posts salvos localmente, ordenados por data.

### Profile
Perfil do usuário com informações pessoais e lista de tarefas.

---

## 🎯 Funcionalidades Técnicas

### Integração com API
- Múltiplos endpoints (posts, users, comments, todos)
- Combine Publishers para dados reativos
- Async/await para operações assíncronas
- Tratamento de erros HTTP

### Persistência
- SwiftData para CRUD de posts salvos
- LocalFileManager para cache de imagens
- Queries reativas com `@Query`

### UX/UI
- Skeleton loading animado
- Empty states informativos
- Transições suaves com animações
- Feedback visual imediato

---

## 🔗 API

Este projeto utiliza a [JSONPlaceholder API](https://jsonplaceholder.typicode.com) como fonte de dados.

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👨‍💻 Autor

**Bruno Carvalho**

---

## 🙏 Agradecimentos

- [JSONPlaceholder](https://jsonplaceholder.typicode.com) pela API de teste
- Comunidade Swift/SwiftUI
