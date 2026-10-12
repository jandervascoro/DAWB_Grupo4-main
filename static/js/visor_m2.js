const dialogoFoto = document.querySelector('#visorFoto');
const imagenVisor = document.querySelector('#imagenVisor');
const nivelZoom = document.querySelector('#nivelZoom');
const botonCerrar = document.querySelector('#cerrarVisor');
const botonAcercar = document.querySelector('#acercarFoto');
const botonAlejar = document.querySelector('#alejarFoto');
const enlacesGaleria = document.querySelectorAll('.galeria a');

if (dialogoFoto && imagenVisor && nivelZoom && typeof dialogoFoto.showModal === 'function') {
    let zoomActual = 1;
    let anchoBase = 0;
    const area = dialogoFoto.querySelector(".visor-contenido");
    const minZoom = 1;
    const maxZoom = 3;
    const pasoZoom = 0.25;

    const actualizarZoom = () => {
        imagenVisor.style.width = (anchoBase * zoomActual) + "px";
        botonAcercar.disabled = !anchoBase || zoomActual >= maxZoom;
        botonAlejar.disabled = !anchoBase || zoomActual <= minZoom;
        nivelZoom.textContent = `${Math.round(zoomActual * 100)}%`;
    };

    const abrirVisor = (src, nombre) => {
        anchoBase = 0;
        imagenVisor.alt = nombre || 'Evidencia fotográfica';
        zoomActual = 1;
        actualizarZoom();
        if (typeof dialogoFoto.showModal === 'function') {
            dialogoFoto.showModal();
            imagenVisor.src = src;
        }
    };

    function ajustar() {
        if (!imagenVisor.naturalWidth) return;
        anchoBase = Math.min(imagenVisor.naturalWidth, area.clientWidth,
            area.clientHeight * imagenVisor.naturalWidth / imagenVisor.naturalHeight);
        zoomActual = 1;
        actualizarZoom();
        area.scrollTo(0, 0);
    }
    imagenVisor.addEventListener('load', ajustar);
    document.querySelector('#ajustarFoto')?.addEventListener('click', ajustar);
    window.addEventListener('resize', () => { if (dialogoFoto.open) ajustar(); });
    dialogoFoto.addEventListener('close', () => imagenVisor.removeAttribute('src'));

    enlacesGaleria.forEach((enlace) => {
        enlace.addEventListener('click', (evento) => {
            if (evento.ctrlKey || evento.metaKey || evento.shiftKey || evento.altKey) return;
            evento.preventDefault();
            abrirVisor(enlace.href, enlace.querySelector('img')?.alt || 'Evidencia fotográfica');
        });
    });

    botonAcercar?.addEventListener('click', () => {
        if (zoomActual < maxZoom) {
            zoomActual = Number((zoomActual + pasoZoom).toFixed(2));
            actualizarZoom();
        }
    });

    botonAlejar?.addEventListener('click', () => {
        if (zoomActual > minZoom) {
            zoomActual = Number((zoomActual - pasoZoom).toFixed(2));
            actualizarZoom();
        }
    });

    botonCerrar?.addEventListener('click', () => {
        if (typeof dialogoFoto.close === 'function') {
            dialogoFoto.close();
        }
    });

    dialogoFoto.addEventListener('click', (evento) => {
        if (evento.target === dialogoFoto) {
            dialogoFoto.close();
        }
    });

    document.addEventListener('keydown', (evento) => {
        if (!dialogoFoto.open) return;

        if (evento.key === 'Escape') {
            dialogoFoto.close();
        }

        if (evento.key === '+' || evento.key === '=') {
            evento.preventDefault();
            botonAcercar?.click();
        }

        if (evento.key === '-' || evento.key === '_') {
            evento.preventDefault();
            botonAlejar?.click();
        }
    });

    actualizarZoom();
}
