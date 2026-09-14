# Guia de Manutenção e Arquitetura para IAs (llms.md)

Este documento é a especificação técnica e o guia de referência para **Modelos de Linguagem (LLMs)** e assistentes de desenvolvimento que forem manter, atualizar ou expandir este repositório (`siliconfps/Windows-7`).

---

## 1. Identidade e Filosofia do Repositório

- **Projeto**: Tema de ícones Windows 7 Aero para ambientes Linux modernos (**XFCE**, **Cinnamon**, **MATE**, **GNOME** / **GTK 3 & GTK 4**).
- **Filosofia Técnica**: 
  - Máxima fidelidade visual ao Windows 7 Aero clássico.
  - Conformidade estrita com a **XDG Icon Theme Specification** (FreeDesktop).
  - Alto desempenho e baixo consumo de CPU/memória nos painéis, Whisker Menu e gerenciadores de arquivo.
  - Zero tolerância para links simbólicos quebrados ou erros de compilação de cache GTK.

---

## 2. Estrutura de Diretórios e Convenções de Ícones

O repositório divide os recursos entre ícones matriciais (PNG) e vetoriais (SVG):

| Diretório | Contexto XDG | Resolução | Tipo no `index.theme` | Formato | Finalidade |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `actions/` | Actions | 128x128 | `Type=Threshold` | PNG | Ações do sistema e menus principais |
| `actions/16/` | Actions | 16x16 | `Type=Threshold` | PNG | Ações para menus compactos e barras |
| `actions/25/` | Actions | 24x24 / 25x25 | `Type=Threshold` | PNG | Ações para barras de ferramentas |
| `actions/32/` | Actions | 32x32 | `Type=Threshold` | PNG | Botões de janelas e barras |
| `actions/48/` | Actions | 48x48 | `Type=Threshold` | PNG | Caixas de diálogo e ações médias |
| `actions/MediaPlayer/`| Actions | 38x38 | `Type=Threshold` | PNG | Controles de tocadores multimídia |
| `animations/` | Animations | 32x32 | `Type=Fixed` | PNG | Animações de progresso/carregamento |
| `apps/` | Applications | 128x128 | `Type=Threshold` | PNG | Ícones principais de aplicativos |
| `apps/16/` | Applications | 16x16 | `Type=Threshold` | PNG | Ícones de aplicativos em listas e bandejas |
| `apps/32/`, `34/`, `48/`, `64/` | Applications | 32x32..64x64 | `Type=Threshold` | PNG | Resoluções intermediárias |
| `categories/` | Categories | 128x128 | `Type=Threshold` | PNG | Categorias do menu iniciar / Whisker |
| `categories/16/` | Categories | 16x16 | `Type=Threshold` | PNG | Categorias em modo compacto |
| `devices/` | Devices | 128x128 | `Type=Threshold` | PNG | Dispositivos e periféricos |
| `devices/16/`, `48/`, `64/` | Devices | 16x16..64x64 | `Type=Threshold` | PNG | Dispositivos em escalas menores |
| `emblems/` | Emblems | 128x128 | `Type=Threshold` | PNG | Emblemas e sobreposições de arquivos |
| `emotes/` | Emotes | 21x21 | `Type=Threshold` | PNG | Emoticons |
| `filesystems/` | Places | 128x128 | `Type=Threshold` | PNG | Diretório legado de pastas e discos |
| `filesystems/16/` | Places | 16x16 | `Type=Threshold` | PNG | Pastas legadas em 16x16 |
| `places/` | Places | 128x128 | `Type=Threshold` | PNG | **Padrão canônico**: symlinks para `filesystems/` |
| `places/16/` | Places | 16x16 | `Type=Threshold` | PNG | **Padrão canônico**: symlinks para `filesystems/16/` |
| `mimetypes/` | MimeTypes | 128x128 | `Type=Threshold` | PNG | Tipos de documentos e extensões |
| `mimetypes/16/`, `48/` | MimeTypes | 16x16..48x48 | `Type=Threshold` | PNG | Mimetypes compactos |
| `notifications/` | Notifications| 128x128 | `Type=Threshold` | PNG | Notificações visuais do sistema |
| `notifications/32/` | Notifications| 45x45 | `Type=Threshold` | PNG | Notificações para bandejas |
| `status/` | Status | 128x128 | `Type=Threshold` | PNG | Status de conexão, clima, bateria |
| `status/18/`..`76/` | Status | Variadas | `Type=Threshold` | PNG | Status para systray e painel |
| `scalable/*` | Vários | 16x16..512x512| `Type=Scalable` | **SVG** | Vetores escaláveis para telas HiDPI |
| `symbolic/*` | Vários | 16x16..512x512| `Type=Scalable` | **SVG** | Ícones monocromáticos simbólicos |
| `applets/` | Fora do tema | N/A | N/A | SVG/PNG | Ícones extras para applets nativos do Cinnamon |
| `extras/` | Fora do tema | N/A | N/A | PNG | Overrides manuais (`start-here/`, `desktop/`) + arquivo morto (`archive/`, ex.: strips GNOME2) |

---

## 3. Regras Críticas do `index.theme`

Ao modificar o [`index.theme`](index.theme), a IA deve obedecer estritamente às seguintes diretrizes:

1. **Separação Obrigatória entre Raster e Scalable**:
   - Pastas com imagens PNG **NUNCA** devem ser configuradas como `Type=Scalable`. Isso força os motores GTK 3 e GTK 4 a redimensionar dinamicamente PNGs de 128px para tamanhos de 24px/32px sem filtro adequado, gerando alto consumo de CPU e borrões na tela.
   - Pastas com PNG devem usar `Type=Threshold` (com `Threshold=2` implícito ou explícito) ou `Type=Fixed`.
   - Pastas com `Type=Scalable` devem conter **exclusivamente arquivos SVG** e declarar `MinSize` e `MaxSize`.
2. **Atualização da Lista `Directories=`**:
   - Qualquer nova pasta de ícones adicionada ao repositório **DEVE** ser incluída na chave `Directories=` na seção `[Icon Theme]`. Pastas não declaradas são ignoradas pelos seletores de ícones do Linux.
3. **Cadeia de Herança (`Inherits`)**:
   - Sempre manter: `Inherits=elementary,Adwaita,gnome,hicolor`.
   - Essa ordem garante que ícones modernos inexistentes no Windows 7 caiam primeiro em temas compatíveis com GTK 3/4 antes de recorrer ao `hicolor`.

---

## 4. Como Adicionar, Editar e Mapear Ícones

### 4.1. Nomenclatura de Arquivos (Proibição de Espaços)
- **NUNCA use espaços em nomes de arquivos**:
  - Exemplo errado: `status/20/net error.png` ou `apps/Community Help.png`.
  - Exemplo correto: `status/20/net_error.png` e `apps/Community_Help.png`.
- *Motivo técnico*: Espaços quebram a validação da tabela hash do utilitário `gtk-update-icon-cache`, gerando a falha `The generated cache was invalid`.

### 4.2. Criação de Links Simbólicos (Symlinks)
- Sempre crie links simbólicos **relativos** (nunca absolutos):
  ```bash
  # Correto (relativo)
  ln -sf ../actions/boot.png apps/xfsm-logout.png
  
  # ERRADO (absoluto)
  ln -sf /home/eli/ia/Windows-7/actions/boot.png apps/xfsm-logout.png
  ```
- **Padrão Reverse-DNS (Modern FreeDesktop)**:
  - Aplicativos modernos utilizam o ID do arquivo `.desktop` (ex.: `org.xfce.thunar`, `org.gnome.Calculator`).
  - Sempre forneça tanto o nome legado quanto o ID moderno via symlink:
    - `apps/org.xfce.thunar.png -> file-manager.png`
    - `apps/thunar.png -> file-manager.png`
- **Ações de Sessão e Energia**:
  - O botão de encerramento do Windows 7 deve apontar para o clássico botão vermelho de energia:
    - `actions/xfsm-logout.png -> boot.png`
    - `actions/system-shutdown.png -> boot.png`
    - `actions/application-exit.png -> boot.png`
    - `actions/16/xfsm-logout.png -> system-shutdown.png`
- **Ações de Bloqueio**:
  - `actions/xflock4.png -> gnome-lockscreen.png`
  - `actions/system-lock-screen.png -> gnome-lockscreen.png`

### 4.3. Modos Git (Filemodes)
- Arquivos de imagem (PNG, SVG): devem ter modo `100644` (ou `100755` se executáveis).
- Links simbólicos: devem ter modo `120000`.
- **Atenção**: Nunca faça commit de um arquivo binário marcado com modo `120000`. Se o Git reportar `typechange`, certifique-se de que o destino não contenha binários no lugar do ponteiro.

---

## 5. Rotina de Testes e Validação Obrigatória (Checklist da IA)

Antes de concluir qualquer tarefa ou realizar commit/push neste repositório, execute os 4 passos de validação:

### Passo 1: Verificar Integridade de Links Simbólicos
Nenhum symlink quebrado pode existir na árvore:
```bash
python3 -c "
import os
broken = [os.path.join(r, f) for r, _, fs in os.walk('.') if '/.git' not in r for f in fs if os.path.islink(os.path.join(r, f)) and not os.path.exists(os.path.join(r, f))]
print('Broken symlinks:', len(broken))
if broken:
    for b in broken[:10]: print(' ->', b)
    exit(1)
"
```

### Passo 2: Gerar e Validar o Cache GTK
O cache precisa ser criado e validado com código de saída 0:
```bash
# Limpar caches residuais antes do teste
rm -f icon-theme.cache .icon-theme.cache

# Gerar o cache
gtk-update-icon-cache -f .

# Validar o cache gerado (flag -v valida o cache existente)
gtk-update-icon-cache -v .

# Remover o cache gerado do working tree para não sujar o git
rm -f icon-theme.cache .icon-theme.cache
```

### Passo 3: Validar o Script de Instalação (`install.sh`)
Testar instalação limpa em diretório temporário:
```bash
./install.sh --destdir /tmp/test-theme-check
rm -rf /tmp/test-theme-check
```

### Passo 4: Validar o PKGBUILD do Arch Linux
Garantir que a sintaxe do pacote esteja íntegra:
```bash
makepkg --printsrcinfo
```

---

## 6. Políticas de Ambiente e Git

- **Elevação de Privilégios (Root)**:
  - **NUNCA execute `sudo`**: O assistente não possui TTY interativo para digitar senhas no terminal.
  - **SEMPRE utilize `pkexec`**: O sistema possui agente gráfico Polkit configurado para exibir o pop-up de senha.
- **GitHub CLI (`gh`)**:
  - A CLI `gh` está autenticada na conta `siliconfps`.
  - Operações de `git push`, criação de releases e PRs devem ser feitas diretamente apontando para `origin main`.
- **Formato dos Commits**:
  - Adote o padrão de Conventional Commits (`feat:`, `fix:`, `cleanup:`, `docs:`, `refactor:`).

---

## 7. Débito Técnico Conhecido (ordem de prioridade)

1. **`scalable/actions/` ainda contém ~95 PNGs** misturados aos SVGs (só `scalable/apps/` foi limpo). Resolvem normalmente, mas não escalam como vetor. Remédio: realocar cada PNG para o diretório raster correspondente ou redesenhar como SVG.
2. **Sem tiers raster 22x22 / 24x24.** Widgets GTK que pedem 22/24px caem nos diretórios `Threshold` + herança `hicolor` — funciona, mas um tier nativo seria mais nítido.
3. **Cobertura de `symbolic/` centrada no Cinnamon.** Nomes simbólicos do GNOME Shell caem no Adwaita — aceitável, expandir oportunisticamente.
4. **`extras/` é instalado junto** (inofensivo, ~30 arquivos) mas não é endereçável pelo tema. Ou excluir da instalação ou promover variantes `start-here` para `apps/` corretamente.

## 8. Regras de Symlinks e Extensões (armadilhas reais)

- **Extensão obrigatória**: o GTK só resolve `.png` / `.svg` / `.xpm`. Arquivos sem extensão são peso morto (ex.: `filesystems/user-home` virou `user-home.svg` + compat-link; symlinks sem extensão foram renomeados com sufixo correto).
- **Profundidade do link relativo**: links em `places/` usam `../filesystems/…`, mas links em `places/16/` ou `apps/48/` exigem `../../…`. Profundidade errada = link dangling (o Passo 1 do §5 detecta).
- **Nomes críticos que devem sempre resolver**: `folder`, `folder-home`, `user-home`, `user-trash`, `user-desktop`, `computer`, `system-shutdown`, `system-reboot`, `system-log-out`, `application-exit`, `dialog-information/warning/error`.

## 9. Log de Manutenção

- **2026-09-13**: `index.theme`: diretórios raster `Scalable → Fixed/Threshold` (alinhado à §3 deste documento e ao `README.md`; `status/20` 22→20, contexto `emotes` → `Emotes`, novo tier `apps/48`, strays realocados); `apps/user-desktop.png` corrompido (166 bytes) substituído por symlink; SVGs sem extensão sufixados; symlinks `folder-home` (×4) e `system-reboot` (×2); strips `gnome-netstatus` arquivados em `extras/archive/`; `install.sh`: correção do re-exec pkexec (duplicação de flags + path relativo), applets respeitam `--destdir` + `nullglob`, novo `--uninstall`; adicionado `COPYING` (GPL-3.0); `PKGBUILD` instala licença e nunca embarca cache stale.
