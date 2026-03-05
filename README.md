# Financial Operations Endpoint

## Abordagem escolhida

Decisões focadas em garantir idempotência e consistência sem adicionar complexidade desnecessária.

- **Idempotência** garantida de duas formas:
  - **Validação no model** (`validates :external_id, uniqueness: true`) impede duplicatas no nível da aplicação.
  - **Índice único no banco** (`add_index :operations, :external_id, unique: true`) garante que mesmo em concorrência alta não sejam criadas operações duplicadas.
- **Evita processamento duplicado em cenários concorrentes**:
  - Uso de `rescue ActiveRecord::RecordNotUnique` permite lidar com requests simultâneas que tentem criar a mesma operação, sem precisar de locks complexos ou transações pesadas.
- Persistência imediata em banco.
- Resposta retorna o registro persistido, mesmo em retries.
- Operações registradas para processamento assíncrono posterior

## Trade-offs

- **Idempotência sem locks ou transactions complexas:** a combinação da **validação no model** e do **índice único no banco** garante que duplicatas não sejam criadas, simplificando a implementação e evitando bloqueios desnecessários.

- **Evitar processamento duplicado em concorrência:**
  - Usar `rescue RecordNotUnique` é simples e eficiente para este caso; protege contra concorrência sem precisar de lock ou transação complexa.

- **Alternativas consideradas para idempotência e concorrência:**
  - `ActiveRecord#lock` (`SELECT ... FOR UPDATE`) → protegeria contra concorrência, mas adicionaria complexidade desnecessária neste caso simples.
  - Bloco de `transaction` → útil em cenários complexos, mas não necessário aqui.
  - **Normalização (downcase) ou conversão do `external_id` para integer** → ignorada para simplicidade, pois `external_id` pode conter letras, vindo de sistemas externos, então precisa permanecer uma string.

## Escala e falhas

- Endpoint leve, fácil de escalar horizontalmente.
- Idempotência garante que retries ou requisições simultâneas não criem duplicatas.
- Operações podem ser processadas posteriormente em jobs assíncronos para não bloquear o endpoint.
- Podemos adicionar logs e métricas para registrar cada operação, permitindo monitoramento e detecção rápida de falhas ou duplicações.
