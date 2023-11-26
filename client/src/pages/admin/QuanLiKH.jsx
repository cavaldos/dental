import khachhang from "../../fakedata/khachhang";
import React from "react";
import { Table, Modal, Button, message, Tag } from "antd";
import ColumnSearch from "~/hooks/useSortTable";
import { useState } from "react";

const KhahHangTable = ({ data }) => {
  const formatDateString = (dateString) => {
    const date = new Date(dateString);
    return date.toLocaleDateString();
  };

  const columns = [
    {
      title: "Số điện thoại",
      dataIndex: "SODT",
      key: "SODT",
    },
    {
      title: "Họ và tên",
      dataIndex: "HOTEN",
      key: "HOTEN",
    },
    {
      title: "Giới tính",
      dataIndex: "PHAI",
      key: "PHAI",
    },
    {
      title: "Ngày sinh",
      dataIndex: "NGAYSINH",
      key: "NGAYSINH",
      render: (text) => formatDateString(text),
    },
    {
      title: "Địa chỉ",
      dataIndex: "DIACHI",
      key: "DIACHI",
    },
    
    {
      title: "Đã khóa",
      dataIndex: "_DAKHOA",
      key: "_DAKHOA",
      render: (_, record) => {
        const tags = record._DAKHOA ? ["Locked"] : ["Open"]; // Cập nhật với các giá trị trạng thái tùy chỉnh của bạn
        return (
          <>
            {tags.map((tag) => {
              let color = tag === "Locked" ? "volcano" : "green"; // Tùy chỉnh màu sắc dựa trên trạng thái
              return (
                <Tag color={color} key={tag}>
                  {tag.toUpperCase()}
                </Tag>
              );
            })}
          </>
        );
      },
    },
    {
      title: "Quản lí",
      key: "action",
      className: "text-center px-[60px] min-w-[120px] ",
      render: (text, record) => (
        <Button
          className="bg-blue-600"
          type="primary"
          size="small"
          onClick={() => message.info(`Edit ${record.HOTEN}`)}
        >
          Sửa
        </Button>
      ),
    },
  ];

  const paginationOptions = {
    pageSize: 10,
    total: data.length,
    showSizeChanger: true,
    showQuickJumper: true,
  };

  return (
    <Table
      className="table-striped w-full"
      columns={columns}
      dataSource={data.map((item, index) => ({ ...item, key: index }))}
      pagination={paginationOptions}
      bordered
      size="middle"
    />
  );
};

const ThemKhachHangMoi = () => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const showModal = () => {
    setIsModalOpen(true);
  };
  const handleOk = () => {
    setIsModalOpen(false);
  };
  const handleCancel = () => {
    setIsModalOpen(false);
  };
  return (
    <>
      <Button className="bg-green-600 mb-4" type="primary" onClick={showModal}>
        Thêm Khách Hàng Mới
      </Button>
      <Modal
        title="Tạo Khách Hàng Mới"
        open={isModalOpen}
        onOk={handleOk}
        onCancel={handleCancel}
        footer={[
          <Button key="cancel" onClick={handleCancel}>
            Hủy
          </Button>,
          <Button
            key="ok"
            type="primary"
            onClick={handleOk}
            className=" bg-blue-500"
          >
            OK
          </Button>,
        ]}
      >
        <p> Viet form tao khach hang moi trong day </p>
      </Modal>
    </>
  );
};

const QuanliKH = () => {
  return (
    <>
      <div className=" w-full ">
        <ThemKhachHangMoi />
        <KhahHangTable data={khachhang} />
      </div>
    </>
  );
};

export default QuanliKH;
