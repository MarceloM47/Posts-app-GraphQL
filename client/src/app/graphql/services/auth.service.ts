import { Injectable } from "@angular/core";
import { BehaviorSubject, Observable, of, throwError } from "rxjs";
import { map, tap } from "rxjs/operators";
import { Router } from "@angular/router";
import { JwtHelperService } from "@auth0/angular-jwt";
import { Apollo } from 'apollo-angular';
import { gql } from 'apollo-angular';
import { LOGIN_MUTATION } from "../mutations/auth.mutations";
import { LoginInput, LoginPayload, LoginResponse } from "../models/auth.model";


@Injectable({
    providedIn: "root"
})
export class AuthService {
    public isAuth = new BehaviorSubject<boolean>(false);
    private token: string = '';
    private tokenExpirationTimer: any;
    private jwtHelper = new JwtHelperService();

    constructor(
        private router: Router,
        private apollo: Apollo
    ) {
        this.autoSignIn();
    }

    autoSignIn() {
        const savedToken = localStorage.getItem('token');
        if (savedToken) {
            try {
                if (!this.jwtHelper.isTokenExpired(savedToken)) {
                    this.token = savedToken;
                    this.isAuth.next(true);

                    const expirationDate = this.jwtHelper.getTokenExpirationDate(savedToken)!;
                    this.setAutoLogout(expirationDate);
                } else {
                    console.warn('Token expirado, cerrando sesión...');
                    this.signOut();
                }
            } catch (error) {
                console.error('Token inválido, cerrando sesión...', error);
                this.signOut();
            }
        }
    }

    signIn(input: LoginInput): Observable<LoginPayload> {
      return this.apollo.mutate<LoginResponse>({
          mutation: LOGIN_MUTATION,
          variables: { input  }
      }).pipe(
          tap(({ data }: any) => {
              if (data?.login?.token) {
                  this.token = data.login.token;
                  localStorage.setItem('user_id', data.login.account.id);
                  localStorage.setItem('token', this.token);
                  localStorage.setItem('username', data.login.account.name);
  
                  this.isAuth.next(true);
  
                  const expirationDate = this.jwtHelper.getTokenExpirationDate(this.token)!;
                  this.setAutoLogout(expirationDate);
  
                  this.router.navigate(['/posts']);
              } else {
                  console.error('No access token received');
              }
          })
      );
    }

    signOut() {
        localStorage.removeItem('token');
        localStorage.removeItem('user_id');
        localStorage.removeItem('username');
        this.isAuth.next(false);
        if (this.tokenExpirationTimer) {
            clearTimeout(this.tokenExpirationTimer);
        }
        this.apollo.client.resetStore();
        this.router.navigate(['/login']);
    }

    private setAutoLogout(expirationDate: Date) {
        const expiresIn = expirationDate.getTime() - new Date().getTime();
        this.tokenExpirationTimer = setTimeout(() => {
            this.signOut();
        }, expiresIn);
    }

    decodeToken(token: string): any {
        const payload = token.split('.')[1];
        return JSON.parse(atob(payload));
    }

    isAuthenticated(): boolean {
        return this.isAuth.value;
    }
}