// JavaScript con DOM, eventos y validaciones, como en S2 y S3.
const fotos = document.querySelector('#fotos');
if (fotos) {
    const error = document.querySelector('#errorFotos');
    const vista = document.querySelector('#vistaPrevia');
    const nombresArchivos = document.querySelector('#nombresArchivos');
    const quitarFotos = document.querySelector('#quitarFotos');
    document.querySelector('#elegirFotos').addEventListener('click', () => fotos.click());
    let urls = [];
    let seleccionadas = [];
    function sincronizar() {
        const datos = new DataTransfer();
        seleccionadas.forEach(f => datos.items.add(f));
        fotos.files = datos.files;
    }

    const limpiarVistaPrevia = () => {
        urls.forEach(url => URL.revokeObjectURL(url));
        urls = [];
        vista.replaceChildren();
    };

    const actualizarTextoArchivos = (archivos) => {
        if (!archivos.length) {
            nombresArchivos.textContent = 'Ningún archivo seleccionado';
            quitarFotos.classList.add('oculto');
            return;
        }

        const nombres = archivos.slice(0, 3).map(file => file.name);
        nombresArchivos.textContent = nombres.join(', ');
        if (archivos.length > 3) {
            nombresArchivos.textContent = `${archivos.length} archivos seleccionados`;
        }
        quitarFotos.classList.remove('oculto');
    };

    const resetInput = () => {
        limpiarVistaPrevia();
        error.textContent = '';
        seleccionadas = [];
        fotos.value = '';
        fotos.setCustomValidity('');
        actualizarTextoArchivos([]);
    };


    function mostrarFotos() {
        limpiarVistaPrevia();
        actualizarTextoArchivos(seleccionadas);
        seleccionadas.forEach((archivo, indice) => {
            const grupo = document.createElement('div');
            grupo.className = 'foto-seleccionada';
            const imagen = document.createElement('img');
            const url = URL.createObjectURL(archivo);
            urls.push(url);
            imagen.src = url;
            imagen.alt = archivo.name;
            const quitar = document.createElement('button');
            quitar.type = 'button';
            quitar.className = 'boton accion-peligro quitar-foto';
            quitar.textContent = 'Quitar';
            quitar.setAttribute('aria-label', 'Quitar ' + archivo.name);
            quitar.addEventListener('click', () => {
                seleccionadas.splice(indice, 1);
                error.textContent = '';
                sincronizar();
                mostrarFotos();
            });
            grupo.append(imagen, quitar);
            vista.appendChild(grupo);
        });
    }
    fotos.addEventListener('change', () => {
        error.textContent = '';
        fotos.setCustomValidity('');
        const archivos = [...seleccionadas];
        Array.from(fotos.files).forEach(archivo => {
            if (!archivos.some(f => f.name === archivo.name && f.size === archivo.size &&
                f.type === archivo.type && f.lastModified === archivo.lastModified)) archivos.push(archivo);
        });
        let mensaje = '';
        if (archivos.length > 3) mensaje = 'Puedes adjuntar hasta 3 fotos. Quita una antes de añadir otra.';
        else if (archivos.some(f => !['image/jpeg', 'image/png', 'image/webp'].includes(f.type))) mensaje = 'Usa imágenes JPG, PNG o WebP.';
        else if (archivos.some(f => f.size > 5 * 1024 * 1024)) mensaje = 'Cada imagen debe pesar hasta 5 MB.';
        if (mensaje) {
            error.textContent = mensaje;
            sincronizar();
            return;
        }
        seleccionadas = archivos;
        sincronizar();
        mostrarFotos();
    });
    fotos.form.addEventListener('reset', resetInput);
    quitarFotos.addEventListener('click', resetInput);
}
