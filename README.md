<h3 align="center">
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/logos/exports/1544x1544_circle.png" width="100" alt="Logo"/><br/>
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
	Catppuccin for <a href="https://github.com/stepanzubkov/where-is-my-sddm-theme">Where is my SDDM theme?</a>
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/misc/transparent.png" height="30" width="0px"/>
</h3>

<p align="center">
	<a href="https://github.com/catppuccin/where-is-my-sddm-theme/stargazers"><img src="https://img.shields.io/github/stars/catppuccin/where-is-my-sddm-theme?colorA=363a4f&colorB=b7bdf8&style=for-the-badge"></a>
	<a href="https://github.com/catppuccin/where-is-my-sddm-theme/issues"><img src="https://img.shields.io/github/issues/catppuccin/where-is-my-sddm-theme?colorA=363a4f&colorB=f5a97f&style=for-the-badge"></a>
	<a href="https://github.com/catppuccin/where-is-my-sddm-theme/contributors"><img src="https://img.shields.io/github/contributors/catppuccin/where-is-my-sddm-theme?colorA=363a4f&colorB=a6da95&style=for-the-badge"></a>
</p>

<p align="center">
	<img src="./assets/preview.webp"/>
</p>

## Previews

<details>
<summary>🌻 Latte</summary>
<img src="./assets/latte.webp"/>
</details>
<details>
<summary>🪴 Frappé</summary>
<img src="./assets/frappe.webp"/>
</details>
<details>
<summary>🌺 Macchiato</summary>
<img src="./assets/macchiato.webp"/>
</details>
<details>
<summary>🌿 Mocha</summary>
<img src="./assets/mocha.webp"/>
</details>

## Usage

1. Download the flavor of your choice.
2. Rename the file to either `theme.conf` or `theme.conf.user`.
3. Move the selected flavor file to `/usr/share/sddm/themes/where_is_my_sddm_theme` or `~/.local/share/sddm/themes/where_is_my_sddm_theme`.

## Customization

This theme is built with [Whiskers](https://github.com/catppuccin/whiskers).

If you wish to hide the cursor in the theme, you can override it as follows:

```console
whiskers where-is-my-sddm-theme.tera --overrides '{"hideCursor": true}'
```

Reinstall the rebuilt theme as described in [Usage](#usage).

For more extensive changes you can edit [where-is-my-sddm-theme.tera](./where-is-my-sddm-theme.tera) to change the theme variables and rebuild with `whiskers where-is-my-sddm-theme.tera`.

## 💝 Thanks to

- [HeitorAugustoLN](https://github.com/HeitorAugustoLN)

&nbsp;

<p align="center">
	<img src="https://raw.githubusercontent.com/catppuccin/catppuccin/main/assets/footers/gray0_ctp_on_line.svg?sanitize=true" />
</p>

<p align="center">
	Copyright &copy; 2021-present <a href="https://github.com/catppuccin" target="_blank">Catppuccin Org</a>
</p>

<p align="center">
	<a href="https://github.com/catppuccin/catppuccin/blob/main/LICENSE"><img src="https://img.shields.io/static/v1.svg?style=for-the-badge&label=License&message=MIT&logoColor=d9e0ee&colorA=363a4f&colorB=b7bdf8"/></a>
</p>
