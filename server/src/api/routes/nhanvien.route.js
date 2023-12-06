import express from "express";
import nhanVienController from "../controllers/nhanvien.controller.js";
import authMiddleware from "../middleware/auth.js";
const router = express.Router();

router.get("/lichRanhNS", nhanVienController.getLichRanhNS);
router.post("/khachHang", nhanVienController.taoTaiKhoanKH);
router.post("/hoaDon", nhanVienController.taoHoaDon);
router.put("/xacNhanHoaDon", nhanVienController.xacNhanThanhToan);
router.put("/matKhau", nhanVienController.doiMatKhau);
router.get("/getAllThuoc", nhanVienController.getAllThuoc);
router.get("/getAllDV", nhanVienController.getAllDV);
router.get("/getAllCa", nhanVienController.getAllCa);
router.get("/hoaDon/:sdt", nhanVienController.getHoaDon);
router.get("/benhAn/:sdt", nhanVienController.xemBenhAn);
router.get("/getAllDSNhaSi", nhanVienController.getAllDSNS);
router.delete("/lichHen", nhanVienController.deleteLichHen);
// Chỗ này add thử nè
router.post("/lichHen",authMiddleware.authenticateToken, khachHangController.xemLichHen);

export default router;
