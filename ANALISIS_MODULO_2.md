# Revisión del módulo 2

Fecha: 11/10/2026. Referencia: guía, páginas 3, 4 y 8.

**No se detectaron funcionalidades específicas de M2 pendientes de implementar en el código:** registro con solicitante automático, hasta tres fotos, validación MIME, almacenamiento en uploads, miniatura en listado e imagen completa con zoom en detalle ya existen.

## Pendientes

- [x] Adaptar M2 a MVC: `ModeloTickets`, `ServicioTickets` y `ServicioFotos`; rutas como controladores y HTML existentes como vistas.
- [ ] Coordinar con M1 la protección JWT de registro, detalle y fotos; actualmente usan sesiones.
- [ ] Coordinar el uso de Bootstrap u otro framework CSS en las vistas de M2; actualmente utilizan CSS propio.
- [x] Verificar el flujo con MySQL y Edge: registro con cero, una y tres fotos, validaciones, almacenamiento, miniaturas, permisos y zoom.

**Fuera del alcance exclusivo de M2:** asignación, estados, SLA, notificaciones, reportes y API global. La fila de M2 no exige expresamente editar/eliminar tickets ni guardar dos archivos físicos por foto.

Pruebas realizadas con datos temporales: HTTP + MySQL y navegador Edge sin ventana. También se verificó rollback ante fallos simulados de SQL y disco. La persistencia se comprobó con nuevos clientes y tras detener el servidor de prueba; no se reinició MySQL ni el equipo.


## ¿Qué significa adaptar M2 a MVC?

**MVC significa Modelo, Vista y Controlador.** Es organizar el código según su responsabilidad:

| Parte | Responsabilidad en M2 | Ejemplo |
| --- | --- | --- |
| Modelo | Manejar los datos y su persistencia. | Guardar y consultar tickets y sus fotos en MySQL. |
| Vista | Mostrar la información y los formularios. | Los HTML de registro, listado y detalle que ya tienes. |
| Controlador | Recibir la petición, coordinar el trabajo y devolver una respuesta. | La ruta `/tickets/nuevo` recibe el formulario y solicita registrar el ticket. |

La separación ya está implementada dentro de `main_comun.py`, sin crear ni renombrar archivos: `ModeloTickets` contiene SQL, `ServicioTickets` valida y coordina las operaciones, y `ServicioFotos` procesa y guarda imágenes.

Las rutas llaman a los servicios y transforman sus resultados en HTML, redirecciones o errores HTTP. Las clases reciben los datos del usuario explícitamente y no dependen de `request`, `session` ni `g`. Se conservan las transacciones y la limpieza de archivos ante errores.

**El usuario sigue viendo las mismas pantallas.** Cambió la organización interna, no las funcionalidades. MVC no obliga a renombrar tus HTML ni establece un número obligatorio de archivos; tampoco consiste únicamente en mover funciones a una clase.

## ¿Qué significa proteger M2 con JWT?

**JWT es un token firmado que permite al servidor verificar la identidad indicada en una petición.** Después de iniciar sesión, M1 emitiría ese token. En cada petición protegida, el servidor comprobaría su firma, vencimiento y validez, además del estado y los permisos del usuario.

En M2 debe protegerse:

- **Crear tickets:** obtener el solicitante del usuario autenticado, no de un ID enviado libremente por el formulario.
- **Listar y consultar tickets:** mostrar únicamente los que ese usuario puede ver.
- **Consultar fotos:** verificar también el acceso al ticket al que pertenecen; conocer la URL no debe dar acceso.

**Hoy ya existe protección mediante sesiones y permisos.** El pendiente es integrar el mecanismo JWT exigido por la guía, no corregir unas rutas que estén completamente públicas. JWT por sí solo no reemplaza las comprobaciones de `puede_ver()` ni garantiza mayor seguridad que una sesión bien implementada.

Para la API, la guía pide enviar el token en `Authorization: Bearer <token>`. En las páginas HTML, formularios e imágenes hay que coordinar con M1 cómo se enviará: los enlaces y las etiquetas `<img>` no añaden ese encabezado automáticamente. Si se usan cookies para el JWT, deben configurarse correctamente y conservar protección CSRF en las operaciones que modifican datos.

El contenido de un JWT firmado **no está cifrado por defecto**: no debe contener contraseñas. M1 también debe resolver la invalidación al cerrar sesión; M2 reutiliza esa autenticación y mantiene sus permisos sobre tickets y fotos.

**MVC y las pruebas están realizados. JWT sigue pendiente de coordinación con M1.**


## Resultado de las pruebas de M2

- Registro HTTP con 0, 1 y 3 fotos (PNG/JPEG/WebP), solicitante automático e historial inicial.
- Rechazo de 4 fotos, MIME incorrecto, contenido falso, más de 5 MiB, más de 20 megapíxeles y campos inválidos; sin registros ni archivos nuevos.
- Fotos completas y miniaturas recuperables; acceso permitido al propietario, administrador y técnico asignado, y denegado a otros usuarios.
- CSRF inválido (400), recursos inexistentes (404), petición excesiva (413) y acceso anónimo redirigido al login.
- Fallos simulados de SQL y disco: rollback y limpieza de evidencias parciales.
- Edge: login real, selección acumulativa, límite de tres, quitar/reponer, envío del formulario y zoom de las tres fotos; comprobación adicional en tamaño móvil.
- Sin errores JavaScript durante el recorrido. Las pruebas usaron usuarios, tickets y fotos temporales; no se modificaron tickets existentes.

Playwright se instaló solo en el entorno virtual para estas pruebas; no es una dependencia de ejecución de la aplicación. No se añadieron archivos de código ni de pruebas al proyecto.
