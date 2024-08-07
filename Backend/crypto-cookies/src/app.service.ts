import { Injectable } from '@nestjs/common';
import { cookies } from './assets/cookies.json';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello World!';
  }

  getCookie(cookieIndex: string) {
    return cookies[cookieIndex].fortune;
  }
}
