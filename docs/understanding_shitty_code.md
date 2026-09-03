result → qué quiere hacer la pantalla: cambiar de screen, salir, quedarse ahí.
command → algo que Bubble Tea/Bubbles necesita ejecutar, por ejemplo mantener funcionando el TextInput.


## Screen Update Convention

Todas las pantallas de NAMI siguen una misma convención para el método `update`.

Cada `Screen#update` devuelve un arreglo con dos valores:

```ruby
[result, command]
```

Esto funciona como un **contrato entre `App` y las Screens**.

### `result`

Indica qué acción quiere realizar la pantalla dentro de NAMI.

Puede ser, por ejemplo:

```ruby
[:kana_menu, nil]
[:hiragana, nil]
[:quit, nil]
[nil, nil]
```

Ejemplos:

```ruby
[:kana_menu, nil]
```

Significa:

> Cambiar a la pantalla `kana_menu`.

Mientras que:

```ruby
[:quit, nil]
```

significa:

> Cerrar la aplicación.

Y:

```ruby
[nil, nil]
```

significa:

> No realizar ninguna navegación.

---

### `command`

El segundo valor contiene un comando que debe regresar a Bubble Tea.

Esto es especialmente importante para componentes de `Bubbles`, como:

```ruby
Bubbles::TextInput
```

Por ejemplo:

```ruby
@input, command = @input.update(message)

[nil, command]
```

En este caso:

- `nil` → NAMI no necesita cambiar de pantalla.
- `command` → Bubble Tea debe procesar el comando generado por `TextInput`.

Esto permite que funcionalidades como el cursor, focus y otros comportamientos internos de los componentes continúen funcionando.

---

## Ejemplo: Study Screen

```ruby
def update(message)
  case message.to_s
  when "enter"
    check_answer

    return [nil, nil]

  when "esc"
    return [:kana_menu, nil]

  when "ctrl+c"
    return [:quit, nil]
  end

  @input, command = @input.update(message)

  [nil, command]
end
```

Dependiendo de la tecla presionada, esta pantalla puede devolver diferentes resultados.

### Usuario presiona `esc`

```ruby
[:kana_menu, nil]
```

NAMI debe regresar al menú de Kana.

### Usuario presiona `ctrl+c`

```ruby
[:quit, nil]
```

NAMI debe cerrarse.

### Usuario escribe en el input

```ruby
@input, command = @input.update(message)

[nil, command]
```

No hay navegación, pero el comando producido por `TextInput` debe regresar a Bubble Tea.

---

## App

`App` recibe ambos valores usando destructuring:

```ruby
result, command = current_screen.update(message)
```

Por ejemplo, si una Screen devuelve:

```ruby
[:kana_menu, nil]
```

Ruby asigna automáticamente:

```ruby
result  = :kana_menu
command = nil
```

Si devuelve:

```ruby
[nil, command]
```

Ruby asigna:

```ruby
result  = nil
command = command
```

Después `App` puede manejar cada responsabilidad por separado:

```ruby
case result
when :quit
  [self, Bubbletea.quit]

when Symbol
  @screen = result

  [self, command]

else
  [self, command]
end
```

---

## Flujo

```text
Bubble Tea
    │
    │ message
    ▼
   App
    │
    │ current_screen.update(message)
    ▼
  Screen
    │
    │
    ▼
[result, command]
    │       │
    │       └── ¿Bubble Tea debe ejecutar algo?
    │
    └────────── ¿NAMI debe navegar o realizar una acción?
```

De esta manera se separan dos responsabilidades:

```text
result  → comportamiento y navegación de NAMI
command → comportamiento interno de Bubble Tea / Bubbles
```

Esto mantiene una interfaz consistente entre `App` y todas las Screens.