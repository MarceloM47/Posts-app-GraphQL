import { Component, DestroyRef, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule, FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../graphql/services/auth.service';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { finalize } from 'rxjs';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  styleUrls: ['./login.component.css'],
  templateUrl: './login.component.html'
})
export class LoginComponent {
  private readonly authService = inject(AuthService);
  private readonly router = inject(Router);
  private readonly fb = inject(FormBuilder);
  private readonly destroyRef = inject(DestroyRef);

  isLoading = false;
  errorMessage = '';

  loginForm = this.fb.group({
    input: this.fb.group({
        email: ['', [Validators.required, Validators.email]],
        password: ['', [Validators.required, Validators.minLength(2)]]
    })
  });

  onSubmit(): void {
    if (this.loginForm.invalid) return;

    this.isLoading = true;
    this.errorMessage = '';

    const formInput = this.loginForm.get('input')?.value;
    
    if (!formInput?.email || !formInput?.password) {
      this.errorMessage = 'Por favor, complete todos los campos';
      this.isLoading = false;
      return;
    }

    const input = {
      email: formInput.email,
      password: formInput.password
    }

    this.authService.signIn(input).pipe(
      takeUntilDestroyed(this.destroyRef),
      finalize(() => this.isLoading = false)
    ).subscribe({
      next: (response: any) => {
        if (response.login.errors?.length) {
          this.errorMessage = response.login.errors.join(', ');
          return;
        }
        if (response.login.token) {
          this.router.navigate(['/posts']);
        } else {
          this.errorMessage = 'Error inesperado durante el inicio de sesión';
        }
      },
      error: (error: any) => {
        this.errorMessage = 'Error al iniciar sesión. Por favor, verifica tus credenciales.';
        console.error('Error en login:', error);
      }
    });
  }

  get emailControl() {
    return this.loginForm.get('email');
  }

  get passwordControl() {
    return this.loginForm.get('password');
  }
}
