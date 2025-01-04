export interface LoginInput {
    email: string;
    password: string;
}

export interface LoginPayload {
    token: string;
    errors?: string[];
    account?: Account;
}

export interface Account {
    id?: string;
    email?: string;
    name?: string;
    accountType?: string;
    companyNumber?: string;
    dateOfBirth?: string;
    createdAt?: string;
    updatedAt?: string;
}

export interface LoginResponse {
    login: LoginPayload;
}
