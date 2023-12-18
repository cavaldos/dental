<<<<<<< HEAD
import React, { useState } from "react";
import { Form, Input } from "antd";
import DentistService from "../../services/dentist";
import { useSelector } from "react-redux";
import { ButtonBlue } from "~/components/button";
const DoiMatKhau = () => {
  const user = useSelector((state) => state.user);
  const { ROLE, HOTEN, PHAI, MANS } = user;
  const [form] = Form.useForm();

  const onFinish = async (values) => {
    const newInfo = {
      mans: MANS,
      matkhaucu: values.matkhaucu,
      matkhaumoi: values.matkhaumoi,
    };
  };
  const onFinishFailed = (errorInfo) => {
    console.log("Failed:", errorInfo);
  };
  return (
    <div className="bg-[#dddddd] w-[800px] h-[500px] rounded-lg p-2 mx-auto">
      <h1 className="text-2xl mb-4">Đổi mật khẩu  </h1>
      <div className="flex flex-col  min-h-[400px]">
        <Form
          name="basic"
          form={form}
          onFinish={onFinish}
          onFinishFailed={onFinishFailed}
          autoComplete="off"
        >
          <Form.Item
            label="Mật Khẩu Cũ"
            name="matkhaucu"
            rules={[
              {
                required: true,
                message: "Vui lòng nhập mật khẩu!",
              },
            ]}
          >
            <Input.Password />
          </Form.Item>
          <Form.Item
            label="Mật Khẩu Mới"
            name="matkhaumoi"
            rules={[
              {
                required: true,
                message: "Vui lòng nhập mật khẩu!",
              },
            ]}
          >
            <Input.Password />
          </Form.Item>
          <Form.Item
            label="Xác Nhận Mật Khẩu Mới"
            name="xacnhanmatkhaumoi"
            rules={[
              ({ getFieldValue }) => ({
                validator(_, value) {
                  if (!value || getFieldValue("matkhaumoi") === value) {
                    return Promise.resolve();
                  }
                  return Promise.reject(
                    new Error(
                      "Mật khẩu xác nhận không trùng khớp với mật khẩu mới!"
                    )
                  );
                },
              }),
            ]}
          >
            <Input.Password />
          </Form.Item>
          <Form.Item>
            <ButtonBlue text="Đổi mật khẩu" htmlType="submit" />
          </Form.Item>
        </Form>
      </div>
    </div>
  );
};
=======
import React, { useEffect, useState } from "react";
import { Form, Input, Select, DatePicker } from "antd";
import GuestService from "../../services/guest";
import dayjs from 'dayjs';
import { changeState } from "../../redux/features/dataSlice";
import { useSelector, useDispatch } from "react-redux";


const layout = {
  labelCol: {
    span: 8,
  },
  wrapperCol: {
    span: 16,
  },
};

const convertBackToDate = (inputDate) => {
  const dateObject = new Date(inputDate);
  const day = dateObject.getDate();
  const month = dateObject.getMonth() + 1;
  const year = dateObject.getFullYear();

  const formattedDate = `${day.toString().padStart(2, '0')}/${month.toString().padStart(2, '0')}/${year}`;

  return formattedDate;
};

const dateFormatList = ['DD/MM/YYYY', 'DD/MM/YY', 'DD-MM-YYYY', 'DD-MM-YY'];

const DoiMatKhau = () => {
  const dispatch = useDispatch();
  const user = useSelector((state) => state.user);
  const [initialValues, setInitialValues] = useState({
    user: {
      phone: user.SODT,
      name: user.HOTEN,
      gender: user.PHAI,
      address: user.DIACHI,
      date: dayjs(convertBackToDate(user.NGAYSINH), dateFormatList[0]),
    },
  });

  useEffect(() => {
    setInitialValues({
      user: {
        phone: user.SODT,
        name: user.HOTEN,
        gender: user.PHAI,
        address: user.DIACHI,
        date: dayjs(convertBackToDate(user.NGAYSINH), dateFormatList[0]),
      },
    });
  }, [user]);

  const onFinish = async (values) => {
    const formData = new FormData();
    const formattedDate = dayjs(values.user.date, dateFormatList[0]).format('YYYY-MM-DD');

    Object.entries(values.user).forEach(([key, value]) => {
      if (key === 'date') {
        formData.append(key, formattedDate);
      } else {
        formData.append(key, value);
      }
    });

    GuestService.capnhatKH({
      //userId: formData.get("maqtv"),
      matkhaucu: formData.get("verify-password"),
      matkhaumoi: formData.get("new-password"),
    }).then((res) => {
      console.log("here")
      console.log(res);
      dispatch(changeState());
    })
  };

  return (
    <div
      className="bg-white p-10 mx-10 sm:px-15 md:px-25 lg:px-40"
      style={{
        borderRadius: "27px",
        boxShadow: "0px 3.111px 3.111px 0px rgba(0, 0, 0, 0.10)",
      }}
    >
      <Form
        {...layout}
        name="nest-messages"
        onFinish={onFinish}
        style={{ maxWidth: "95%" }}
        initialValues={initialValues}
      >
        <Form.Item
          name={["user", "phone"]}
          label="Số điện thoại"
          rules={[
            {
              required: true,
              message: "Vui lòng nhập số điện thoại!",
            },
          ]}
          labelCol={{
            span: 5,
          }}
          wrapperCol={{
            span: 19,
          }}
        >
          <Input disabled={true} />
        </Form.Item>

        <Form.Item
          name={["user", "verify-password"]}
          label="Xác nhận mật khẩu"
          rules={[
            {
              required: true,
              message: "Vui lòng xác nhận mật khẩu!",
            },
          ]}
          labelCol={{
            span: 5,
          }}
          wrapperCol={{
            span: 19,
          }}
        >
          <Input.Password />
        </Form.Item>

        <Form.Item
          name={["user", "new-password"]}
          label="Mật khẩu mới"
          rules={[
            {
              required: true,
              message: "Vui lòng xác nhận mật khẩu!",
            },
            ({ getFieldValue }) => ({
              validator(_, value) {
                if (value && getFieldValue(["user", "verify-password"]) !== value) {
                  return Promise.resolve();
                }
                return Promise.reject(new Error('Mật khẩu mới cần khác mật khẩu cũ!'));
              },
            }),

          ]}
          labelCol={{
            span: 5,
          }}
          wrapperCol={{
            span: 19,
          }}

        >
          <Input.Password />
        </Form.Item>

        <Form.Item
          wrapperCol={{
            ...layout.wrapperCol,
            offset: 5,
          }}
          style={{ marginBottom: 0 }}
        >
          <button className="bg-grin font-montserrat font-bold text-base text-white py-2 px-5 rounded-lg hover:bg-darkgrin active:bg-grin">
            CẬP NHẬT
          </button>
        </Form.Item>
      </Form>
    </div>
  );
};

>>>>>>> 8b1bb907918e39062c6b93c5b672e29fed62bcb5
export default DoiMatKhau;
