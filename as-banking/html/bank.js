let accountData = null;

// NUI Message Handler
window.addEventListener('message', function(event) {
    const data = event.data;
    
    if (data.action === 'openBank') {
        accountData = data.data;
        document.getElementById('bankContainer').style.display = 'flex';
        updateDisplay();
    } else if (data.action === 'updateAccount') {
        accountData = data.data;
        updateDisplay();
    }
});

// Update Display
function updateDisplay() {
    if (!accountData) return;
    
    document.getElementById('accountName').textContent = accountData.name;
    document.getElementById('accountId').textContent = 'ID: ' + accountData.citizenid;
    document.getElementById('bankBalance').textContent = '$' + accountData.balance.toLocaleString();
    document.getElementById('cashBalance').textContent = '$' + accountData.cash.toLocaleString();
    
    // Update recent transactions
    updateRecentTransactions();
    updateTransactionsList();
    updateLoans();
    updateCard();
}

// Update Recent Transactions
function updateRecentTransactions() {
    const list = document.getElementById('recentList');
    if (!accountData.transactions || accountData.transactions.length === 0) {
        list.innerHTML = '<p style="color: #9CA3AF; text-align: center; padding: 20px;">No recent transactions</p>';
        return;
    }
    
    const recent = accountData.transactions.slice(0, 5);
    list.innerHTML = recent.map(tx => `
        <div class="transaction-item">
            <div class="transaction-info">
                <div class="transaction-type">${tx.transaction_type.toUpperCase()}</div>
                <div class="transaction-desc">${tx.description}</div>
            </div>
            <div class="transaction-amount ${tx.amount > 0 ? 'positive' : 'negative'}">
                ${tx.amount > 0 ? '+' : ''}$${Math.abs(tx.amount).toLocaleString()}
            </div>
        </div>
    `).join('');
}

// Update All Transactions
function updateTransactionsList() {
    const list = document.getElementById('transactionsList');
    if (!accountData.transactions || accountData.transactions.length === 0) {
        list.innerHTML = '<p style="color: #9CA3AF; text-align: center; padding: 20px;">No transactions found</p>';
        return;
    }
    
    list.innerHTML = accountData.transactions.map(tx => `
        <div class="transaction-item">
            <div class="transaction-info">
                <div class="transaction-type">${tx.transaction_type.toUpperCase()}</div>
                <div class="transaction-desc">${tx.description} - ${new Date(tx.created_at).toLocaleString()}</div>
            </div>
            <div class="transaction-amount ${tx.amount > 0 ? 'positive' : 'negative'}">
                ${tx.amount > 0 ? '+' : ''}$${Math.abs(tx.amount).toLocaleString()}
            </div>
        </div>
    `).join('');
}

// Update Loans
function updateLoans() {
    const container = document.getElementById('activeLoans');
    if (!accountData.loans || accountData.loans.length === 0) {
        container.innerHTML = '<p style="color: #9CA3AF; margin-bottom: 20px;">No active loans</p>';
        return;
    }
    
    container.innerHTML = accountData.loans.map(loan => `
        <div class="loan-item">
            <div class="loan-header">
                <div class="loan-amount">$${loan.remaining.toLocaleString()}</div>
                <div class="loan-status">${loan.status.toUpperCase()}</div>
            </div>
            <div class="loan-details">
                <div class="loan-detail">Original: <strong>$${loan.amount.toLocaleString()}</strong></div>
                <div class="loan-detail">Interest: <strong>${loan.interest_rate}%</strong></div>
                <div class="loan-detail">Remaining: <strong>$${loan.remaining.toLocaleString()}</strong></div>
                <div class="loan-detail">Due: <strong>${new Date(loan.payment_due).toLocaleDateString()}</strong></div>
            </div>
            <div class="loan-actions">
                <input type="number" id="payLoanAmount_${loan.id}" placeholder="Payment amount" style="width: 200px; margin-right: 10px; padding: 8px; border-radius: 6px; border: none;">
                <button onclick="payLoan(${loan.id})">Make Payment</button>
            </div>
        </div>
    `).join('');
}

// Update Card
function updateCard() {
    const container = document.getElementById('cardInfo');
    if (!accountData.card) {
        container.innerHTML = `
            <p style="color: #9CA3AF; margin-bottom: 20px;">You don't have a bank card yet</p>
            <button class="submit-btn" onclick="requestCard()">Get Bank Card ($500)</button>
        `;
        return;
    }
    
    container.innerHTML = `
        <div style="background: linear-gradient(145deg, #8B5CF6, #6D28D9); border-radius: 15px; padding: 30px; max-width: 400px; color: white;">
            <div style="font-size: 24px; font-weight: 700; margin-bottom: 20px;">AS BANK</div>
            <div style="font-family: 'Courier New', monospace; font-size: 20px; letter-spacing: 3px; margin-bottom: 15px;">
                ${accountData.card.card_number.match(/.{1,4}/g).join(' ')}
            </div>
            <div style="display: flex; justify-content: space-between;">
                <div>
                    <div style="font-size: 10px; opacity: 0.8;">CARDHOLDER</div>
                    <div style="font-size: 14px; font-weight: 600;">${accountData.name}</div>
                </div>
                <div>
                    <div style="font-size: 10px; opacity: 0.8;">PIN</div>
                    <div style="font-size: 14px; font-weight: 600;">${accountData.card.pin}</div>
                </div>
            </div>
        </div>
    `;
}

// Tab Navigation
document.querySelectorAll('.sidebar-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        const tab = this.getAttribute('data-tab');
        
        // Update sidebar
        document.querySelectorAll('.sidebar-btn').forEach(b => b.classList.remove('active'));
        this.classList.add('active');
        
        // Update content
        document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
        document.getElementById(tab + 'Tab').classList.add('active');
    });
});

// Quick Actions
document.querySelectorAll('.action-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        const action = this.getAttribute('data-action');
        const targetBtn = document.querySelector(`.sidebar-btn[data-tab="${action}"]`);
        if (targetBtn) {
            targetBtn.click();
        }
    });
});

// Deposit
document.getElementById('depositBtn').addEventListener('click', function() {
    const amount = parseInt(document.getElementById('depositAmount').value);
    if (!amount || amount <= 0) return;
    
    fetch(`https://${GetParentResourceName()}/deposit`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ amount: amount })
    }).then(resp => resp.json()).then(success => {
        if (success) {
            document.getElementById('depositAmount').value = '';
        }
    });
});

// Withdraw
document.getElementById('withdrawBtn').addEventListener('click', function() {
    const amount = parseInt(document.getElementById('withdrawAmount').value);
    if (!amount || amount <= 0) return;
    
    fetch(`https://${GetParentResourceName()}/withdraw`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ amount: amount, isATM: false })
    }).then(resp => resp.json()).then(success => {
        if (success) {
            document.getElementById('withdrawAmount').value = '';
        }
    });
});

// Transfer
document.getElementById('transferBtn').addEventListener('click', function() {
    const targetId = document.getElementById('transferTarget').value;
    const amount = parseInt(document.getElementById('transferAmount').value);
    
    if (!targetId || !amount || amount <= 0) return;
    
    fetch(`https://${GetParentResourceName()}/transfer`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ targetId: targetId, amount: amount })
    }).then(resp => resp.json()).then(success => {
        if (success) {
            document.getElementById('transferTarget').value = '';
            document.getElementById('transferAmount').value = '';
        }
    });
});

// Request Loan
document.getElementById('loanBtn').addEventListener('click', function() {
    const amount = parseInt(document.getElementById('loanAmount').value);
    if (!amount || amount <= 0) return;
    
    fetch(`https://${GetParentResourceName()}/requestLoan`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ amount: amount })
    }).then(resp => resp.json()).then(success => {
        if (success) {
            document.getElementById('loanAmount').value = '';
        }
    });
});

// Pay Loan
function payLoan(loanId) {
    const amount = parseInt(document.getElementById('payLoanAmount_' + loanId).value);
    if (!amount || amount <= 0) return;
    
    fetch(`https://${GetParentResourceName()}/payLoan`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ loanId: loanId, amount: amount })
    }).then(resp => resp.json()).then(success => {
        if (success) {
            document.getElementById('payLoanAmount_' + loanId).value = '';
        }
    });
}

// Request Card
function requestCard() {
    fetch(`https://${GetParentResourceName()}/getCard`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

// Close Bank
document.getElementById('closeBtn').addEventListener('click', closeBank);

function closeBank() {
    document.getElementById('bankContainer').style.display = 'none';
    accountData = null;
    
    // Reset to overview tab
    document.querySelectorAll('.sidebar-btn').forEach(b => b.classList.remove('active'));
    document.querySelector('.sidebar-btn[data-tab="overview"]').classList.add('active');
    document.querySelectorAll('.tab-content').forEach(t => t.classList.remove('active'));
    document.getElementById('overviewTab').classList.add('active');
    
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

// ESC Key
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeBank();
    }
});

// Helper
function GetParentResourceName() {
    return 'as-banking';
}
