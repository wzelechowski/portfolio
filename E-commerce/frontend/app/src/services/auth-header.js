import Cookies from 'js-cookie';

export default function authHeader() {
  let accessToken = Cookies.get('accessToken');

  if (accessToken) {
    return { Authorization: 'Bearer ' + accessToken };
  } else {
    return {};
  }
}
