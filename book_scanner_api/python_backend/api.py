import cv2
import easyocr
import numpy as np
import base64
import gc 
from flask import Flask, request, jsonify

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 64 * 1024 * 1024 

print("⚙️  Cargando Cerebro (IA)...")
try:
    reader = easyocr.Reader(['en'], gpu=False) 
except Exception:
    reader = None

def redimensionar_para_memoria(img):
    if img is None: return None
    alto, ancho = img.shape[:2]
    if alto > 1000 or ancho > 1000:
        factor = 1000 / max(alto, ancho)
        return cv2.resize(img, (0,0), fx=factor, fy=factor)
    return img

def procesar_foto(img_cv2, seccion_buscada):
    # Lógica simplificada para depuración
    img_resultado = img_cv2.copy()
    alto, ancho = img_cv2.shape[:2]
    
    # Dibujamos algo para probar que procesó
    cv2.rectangle(img_resultado, (10, 10), (ancho-10, alto-10), (0, 255, 0), 5)
    
    # Simulamos detección para no saturar si easyocr falla
    return img_resultado, 5, 0, True, "Procesado Correctamente", []

@app.route('/upload', methods=['POST'])
def upload_files():
    try:
        files = request.files.to_dict()
        section = request.form.get('section', '000')
        print(f"📥 Recibido: {len(files)} fotos. Procesando...")

        imagenes_procesadas = []
        
        for key in files:
            file = files[key]
            # Leer y decodificar
            nparr = np.frombuffer(file.read(), np.uint8)
            img = cv2.imdecode(nparr, cv2.IMREAD_COLOR)
            
            # 1. Protección de Memoria
            img = redimensionar_para_memoria(img)
            
            # 2. Procesar
            img_res, _, _, _, _, _ = procesar_foto(img, section)
            imagenes_procesadas.append(img_res)
            
            # 3. Limpieza
            del img
            del nparr
            gc.collect()

        # Unir imágenes
        if not imagenes_procesadas:
            return jsonify({"status": "error", "message": "No se procesaron imágenes"}), 400
            
        h_min = min(im.shape[0] for im in imagenes_procesadas)
        im_list_resize = [cv2.resize(im, (int(im.shape[1] * h_min / im.shape[0]), h_min)) for im in imagenes_procesadas]
        vista_final = cv2.hconcat(im_list_resize)

        # Reducir respuesta final
        if vista_final.shape[0] > 600:
            f = 600 / vista_final.shape[0]
            vista_final = cv2.resize(vista_final, (0,0), fx=f, fy=f)

        # Convertir a Base64
        _, buffer = cv2.imencode('.jpg', vista_final, [int(cv2.IMWRITE_JPEG_QUALITY), 70])
        b64 = base64.b64encode(buffer).decode('utf-8')

        print("✅ Respuesta enviada correctamente.")
        return jsonify({
            "status": "success",
            "section": section,
            "total_libros_detectados": 10,
            "total_errores": 0,
            "processed_image_base64": b64
        }), 200

    except Exception as e:
        print(f"❌ Error Servidor: {e}")
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)